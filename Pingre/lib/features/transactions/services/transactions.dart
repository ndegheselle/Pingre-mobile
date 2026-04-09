import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:pingre/common/models/time_range.dart';
import 'package:pingre/features/tags/models/tag.dart';
import 'package:pingre/features/tags/models/tags_selection.dart';
import 'package:pingre/features/transactions/models/transaction.dart';

class TransactionsService extends ChangeNotifier {
  final Map<String, Transaction> _transactionsMap = _generateFakeData();

  static Map<String, Transaction> _generateFakeData() {
    final rng = Random();

    final primaryTags = [
      Tag(name: 'Food'),
      Tag(name: 'Transport'),
      Tag(name: 'Shopping'),
      Tag(name: 'Health'),
      Tag(name: 'Entertainment'),
      Tag(name: 'Housing'),
      Tag(name: 'Travel'),
    ];

    var list = List.generate(200, (i) {
      final daysAgo = rng.nextInt(365);
      final primary = primaryTags[rng.nextInt(primaryTags.length)];
      return Transaction(
        value: Decimal.parse(
          (rng.nextDouble() * 500).roundToDouble().toString(),
        ),
        date: DateTime.now().subtract(Duration(days: daysAgo)),
        tags: TagsSelection(primary: primary, secondaries: [
          primaryTags[rng.nextInt(primaryTags.length)],
          primaryTags[rng.nextInt(primaryTags.length)],
        ]),
        notes: 'Transaction $i',
      );
    });
    return {for (var e in list) e.id: e};
  }

  Future<List<Transaction>> getByRange(TimeRange range) async {
    return _transactionsMap.values
        .where((t) => t.date.isBefore(range.end) && t.date.isAfter(range.start))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Transaction create(Transaction transaction) {
    _transactionsMap[transaction.id] = transaction;
    notifyListeners();
    return transaction;
  }

  void update(
    String id, {
    Decimal? value,
    TagsSelection? tags,
    DateTime? date,
    String? notes,
  }) {
    if (!_transactionsMap.containsKey(id)) return;

    _transactionsMap[id] = _transactionsMap[id]!.copyWith(
      value: value,
      tags: tags,
      date: date,
      notes: notes,
    );
    notifyListeners();
  }

  void remove(String id) {
    _transactionsMap.remove(id);
    notifyListeners();
  }

  /// Returns true if a transaction already exists on the same calendar day
  /// with the same primary tag — used to prevent duplicate recurring entries.
  bool existsByDateAndPrimaryTag(DateTime date, Tag primaryTag) {
    return _transactionsMap.values.any((t) =>
        t.date.year == date.year &&
        t.date.month == date.month &&
        t.date.day == date.day &&
        t.tags.primary.name == primaryTag.name);
  }
}
