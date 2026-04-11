import 'package:flutter/material.dart';
import 'package:pingre/common/models/time_range.dart';
import 'package:pingre/database/drift.dart';
import 'package:pingre/features/recurring/models/recurring.dart';
import 'package:pingre/features/recurring/models/recurring.db.dart';
import 'package:pingre/features/tags/models/tag.dart';
import 'package:pingre/features/tags/models/tags_selection.dart';
import 'package:pingre/features/tags/services/tags.dart';
import 'package:pingre/features/transactions/models/transaction.dart';
import 'package:pingre/features/transactions/services/transactions.dart';

class RecurringTransactionsService extends ChangeNotifier {
  final AppDatabase _db;
  final TagsService _tagsService;

  final Map<String, RecurringTransaction> _recurringTransactionsMap = {};
  Iterable<RecurringTransaction> get recurringTransactions =>
      _recurringTransactionsMap.values;

  RecurringTransactionsService(this._db, this._tagsService);

  Future<void> initialize() async {
    final rows = await _db.select(_db.recurringTransactionsTable).get();
    _recurringTransactionsMap.clear();
    for (final row in rows) {
      final tags = await _resolveTagsForRecurring(row.id);
      if (tags == null) continue;
      _recurringTransactionsMap[row.id] =
          RecurringTransactionMapper.fromData(row, tags);
    }
    notifyListeners();
  }

  Future<RecurringTransaction> create(
    RecurringTransaction recurringTransaction,
  ) async {
    await _db
        .into(_db.recurringTransactionsTable)
        .insert(recurringTransaction.toData());
    await _writeRecurringTransactionTags(
      recurringTransaction.id,
      recurringTransaction.transaction.tags,
    );
    _recurringTransactionsMap[recurringTransaction.id] = recurringTransaction;
    notifyListeners();
    return recurringTransaction;
  }

  Iterable<RecurringTransaction> search(String name) {
    return recurringTransactions.where(
      (rt) => rt.name.toLowerCase().contains(name.trim().toLowerCase()),
    );
  }

  Iterable<RecurringTransaction> filterByRange(TimeRangeUnit range) {
    return recurringTransactions.where((rt) => rt.range == range);
  }

  Future<void> update(
    String id, {
    String? name,
    Transaction? transaction,
    TimeRangeUnit? range,
  }) async {
    if (!_recurringTransactionsMap.containsKey(id)) return;

    final updated = _recurringTransactionsMap[id]!.copyWith(
      name: name,
      transaction: transaction,
      range: range,
    );
    await _db.update(_db.recurringTransactionsTable).replace(updated.toData());
    if (transaction != null) {
      await _writeRecurringTransactionTags(id, transaction.tags);
    }
    _recurringTransactionsMap[id] = updated;
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await (_db.delete(_db.recurringTransactionTagsTable)
          ..where((t) => t.recurringTransactionId.equals(id)))
        .go();
    await (_db.delete(_db.recurringTransactionsTable)
          ..where((t) => t.id.equals(id)))
        .go();
    _recurringTransactionsMap.remove(id);
    notifyListeners();
  }

  /// Generates and adds all recurring transaction occurrences that should have
  /// happened between [lastRun] and now. Safe to call non-blocking at app start.
  /// A duplicate guard prevents adding a transaction that already exists on the
  /// same calendar day with the same primary tag.
  Future<void> applyMissedRecurring(
    TransactionsService transactionsService,
    DateTime? lastRun,
  ) async {
    final now = DateTime.now();
    if (lastRun == null || !lastRun.isBefore(now)) return;

    for (final recurring in recurringTransactions) {
      for (final date in _getOccurrencesBetween(recurring, lastRun, now)) {
        if (!await transactionsService.existsByDateAndPrimaryTag(
          date,
          recurring.transaction.tags.primary,
        )) {
          await transactionsService.create(
            recurring.transaction.copyWith(date: date),
          );
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<TagsSelection?> _resolveTagsForRecurring(
    String recurringTransactionId,
  ) async {
    final tagRows = await (
      _db.select(_db.recurringTransactionTagsTable)
        ..where(
          (t) => t.recurringTransactionId.equals(recurringTransactionId),
        )
    ).get();

    final primaryRow =
        tagRows.where((r) => r.isPrimary).firstOrNull;
    if (primaryRow == null) return null;

    final primary = _tagsService.getTagById(primaryRow.tagId);
    if (primary == null) return null;

    final secondaries = tagRows
        .where((r) => !r.isPrimary)
        .map((r) => _tagsService.getTagById(r.tagId))
        .whereType<Tag>()
        .toList();

    return TagsSelection(primary: primary, secondaries: secondaries);
  }

  /// Replaces all tag links for [recurringTransactionId] with [tags].
  Future<void> _writeRecurringTransactionTags(
    String recurringTransactionId,
    TagsSelection tags,
  ) async {
    await (_db.delete(_db.recurringTransactionTagsTable)
          ..where(
            (t) => t.recurringTransactionId.equals(recurringTransactionId),
          ))
        .go();

    await _db.batch((batch) {
      batch.insert(
        _db.recurringTransactionTagsTable,
        RecurringTransactionTagsTableData(
          recurringTransactionId: recurringTransactionId,
          tagId: tags.primary.id,
          isPrimary: true,
        ),
      );
      for (final tag in tags.secondaries) {
        batch.insert(
          _db.recurringTransactionTagsTable,
          RecurringTransactionTagsTableData(
            recurringTransactionId: recurringTransactionId,
            tagId: tag.id,
            isPrimary: false,
          ),
        );
      }
    });
  }

  List<DateTime> _getOccurrencesBetween(
    RecurringTransaction recurring,
    DateTime from,
    DateTime to,
  ) {
    final occurrences = <DateTime>[];
    var current = recurring.transaction.date;

    while (!current.isAfter(from)) {
      current = _addPeriod(current, recurring.range);
    }
    while (!current.isAfter(to)) {
      occurrences.add(current);
      current = _addPeriod(current, recurring.range);
    }
    return occurrences;
  }

  DateTime _addPeriod(DateTime date, TimeRangeUnit unit) {
    switch (unit) {
      case TimeRangeUnit.day:
        return date.add(const Duration(days: 1));
      case TimeRangeUnit.week:
        return date.add(const Duration(days: 7));
      case TimeRangeUnit.twoWeeks:
        return date.add(const Duration(days: 14));
      case TimeRangeUnit.month:
        return DateTime(
            date.year, date.month + 1, date.day, date.hour, date.minute, date.second);
      case TimeRangeUnit.quarter:
        return DateTime(
            date.year, date.month + 3, date.day, date.hour, date.minute, date.second);
      case TimeRangeUnit.year:
        return DateTime(
            date.year + 1, date.month, date.day, date.hour, date.minute, date.second);
    }
  }
}
