import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:pingre/common/models/time_range.dart';
import 'package:pingre/database/drift.dart';
import 'package:pingre/features/tags/models/tag.dart';
import 'package:pingre/features/tags/models/tags_selection.dart';
import 'package:pingre/features/tags/services/tags.dart';
import 'package:pingre/features/transactions/models/transaction.dart';
import 'package:pingre/features/transactions/models/transaction.db.dart';

class TransactionsService extends ChangeNotifier {
  final AppDatabase _db;
  final TagsService _tagsService;

  TransactionsService(this._db, this._tagsService);

  Future<List<Transaction>> getByRange(TimeRange range) async {
    final rows = await (
      _db.select(_db.transactionsTable)
        ..where(
          (t) =>
              t.date.isBiggerThan(Variable(range.start)) &
              t.date.isSmallerThan(Variable(range.end)),
        )
        ..orderBy([(t) => OrderingTerm.desc(t.date)])
    ).get();

    final tagsMap = await _resolveTagsForTransactions(rows.map((r) => r.id).toList());
    return rows
        .where((r) => tagsMap.containsKey(r.id))
        .map((r) => TransactionMapper.fromData(r, tagsMap[r.id]!))
        .toList();
  }

  /// Calculates the average transaction value per tag over the [numberOfPeriods]
  /// periods preceding [currentRange].
  Future<HashMap<String, Decimal>> getPreviousAverages(
    TimeRange currentRange, {
    int numberOfPeriods = 3,
    bool onlyPrimary = false,
  }) async {
    TimeRange oldestRange = currentRange;
    for (int i = 1; i <= numberOfPeriods; i++) {
      oldestRange = oldestRange.previous();
    }
    final fullRange = TimeRange(
      unit: currentRange.unit,
      start: oldestRange.start,
      end: currentRange.start.subtract(const Duration(days: 1)),
    );

    final rows = await (
      _db.select(_db.transactionsTable)
        ..where(
          (t) =>
              t.date.isBiggerThan(Variable(fullRange.start)) &
              t.date.isSmallerThan(Variable(fullRange.end)),
        )
    ).get();

    final tagsMap = await _resolveTagsForTransactions(rows.map((r) => r.id).toList());

    final HashMap<String, Decimal> averages = HashMap();
    for (final row in rows) {
      final tags = tagsMap[row.id];
      if (tags == null) continue;
      final value = Decimal.parse(row.value);
      final tagsToConsider = onlyPrimary ? [tags.primary] : tags.all;
      for (final tag in tagsToConsider) {
        averages[tag.id] = (averages[tag.id] ?? Decimal.zero) + value;
      }
    }
    for (final key in averages.keys) {
      averages[key] = (averages[key]! / Decimal.fromInt(numberOfPeriods))
          .toDecimal(scaleOnInfinitePrecision: 2);
    }
    return averages;
  }

  Future<Transaction> create(Transaction transaction) async {
    await _db.into(_db.transactionsTable).insert(transaction.toData());
    await _writeTransactionTags(transaction.id, transaction.tags);
    notifyListeners();
    return transaction;
  }

  Future<void> update(
    String id, {
    Decimal? value,
    TagsSelection? tags,
    DateTime? date,
    String? notes,
  }) async {
    final existing = await (
      _db.select(_db.transactionsTable)..where((t) => t.id.equals(id))
    ).getSingleOrNull();
    if (existing == null) return;

    await _db.update(_db.transactionsTable).replace(
          TransactionsTableData(
            id: id,
            value: value?.toString() ?? existing.value,
            date: date ?? existing.date,
            notes: notes ?? existing.notes,
          ),
        );
    if (tags != null) {
      await _writeTransactionTags(id, tags);
    }
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await (_db.delete(_db.transactionTagsTable)
          ..where((t) => t.transactionId.equals(id)))
        .go();
    await (_db.delete(_db.transactionsTable)..where((t) => t.id.equals(id)))
        .go();
    notifyListeners();
  }

  /// Returns true if a transaction already exists on the same calendar day
  /// with the same primary tag — used to prevent duplicate recurring entries.
  Future<bool> existsByDateAndPrimaryTag(DateTime date, Tag primaryTag) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final query = _db.select(_db.transactionsTable).join([
      innerJoin(
        _db.transactionTagsTable,
        _db.transactionTagsTable.transactionId
            .equalsExp(_db.transactionsTable.id),
      ),
    ])
      ..where(
        _db.transactionsTable.date.isBiggerOrEqualValue(start) &
            _db.transactionsTable.date.isSmallerThanValue(end) &
            _db.transactionTagsTable.tagId.equals(primaryTag.id) &
            _db.transactionTagsTable.isPrimary.equals(true),
      );

    return (await query.get()).isNotEmpty;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Fetches tag links for all [transactionIds] in one query and resolves them
  /// against the [TagsService] cache. Returns a map keyed by transaction id.
  Future<Map<String, TagsSelection>> _resolveTagsForTransactions(
    List<String> transactionIds,
  ) async {
    if (transactionIds.isEmpty) return {};

    final tagRows = await (
      _db.select(_db.transactionTagsTable)
        ..where((t) => t.transactionId.isIn(transactionIds))
    ).get();

    final byTxId = <String, List<TransactionTagsTableData>>{};
    for (final row in tagRows) {
      byTxId.putIfAbsent(row.transactionId, () => []).add(row);
    }

    final result = <String, TagsSelection>{};
    for (final txId in transactionIds) {
      final rows = byTxId[txId] ?? [];
      final primaryRow = rows.firstWhereOrNull((r) => r.isPrimary);
      if (primaryRow == null) continue;

      final primary = _tagsService.getTagById(primaryRow.tagId);
      if (primary == null) continue;

      final secondaries = rows
          .where((r) => !r.isPrimary)
          .map((r) => _tagsService.getTagById(r.tagId))
          .whereType<Tag>()
          .toList();

      result[txId] = TagsSelection(primary: primary, secondaries: secondaries);
    }
    return result;
  }

  /// Replaces all tag links for [transactionId] with the given [tags].
  Future<void> _writeTransactionTags(
    String transactionId,
    TagsSelection tags,
  ) async {
    await (_db.delete(_db.transactionTagsTable)
          ..where((t) => t.transactionId.equals(transactionId)))
        .go();

    await _db.batch((batch) {
      batch.insert(
        _db.transactionTagsTable,
        TransactionTagsTableData(
          transactionId: transactionId,
          tagId: tags.primary.id,
          isPrimary: true,
        ),
      );
      for (final tag in tags.secondaries) {
        batch.insert(
          _db.transactionTagsTable,
          TransactionTagsTableData(
            transactionId: transactionId,
            tagId: tag.id,
            isPrimary: false,
          ),
        );
      }
    });
  }
}
