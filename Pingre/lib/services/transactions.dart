import 'dart:math';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:pingre/models/time_range.dart';
import 'package:pingre/services/tags.dart';
import 'package:uuid/uuid.dart';

/// A selection of tags, a [primary] tag act like a category and is used to group and create reports
class TagsSelection {
  /// Main tag of the selection
  final Tag primary;

  /// Secondaries tags
  final List<Tag> secondaries;
  List<Tag> get all => [primary, ...secondaries];

  TagsSelection({required this.primary, List<Tag>? secondaries})
    : secondaries = secondaries ?? [];
}

/// One line of transaction
class Transaction {
  final String id;
  final Decimal value;

  final TagsSelection tags;

  final DateTime date;
  final String notes;

  Transaction({
    required this.value,
    required this.date,
    required this.tags,
    this.notes = "",
    String? id,
  }) : id = id ?? const Uuid().v4();
}

/// A group of transactions
class TransactionsGroup {
  final TimeRange range;
  final String name;
  final Decimal total;
  final List<Transaction> transactions;

  TransactionsGroup({required this.range, required this.name, required this.transactions})
    : total = transactions.fold(.zero, (a, b) => a + b.value);
}

class TransactionsService extends ChangeNotifier {
  final List<Transaction> _allTransactions = _generateFakeData();
  static List<Transaction> _generateFakeData() {
    final rng = Random();
    return List.generate(200, (i) {
      final daysAgo = rng.nextInt(365);
      return Transaction(
        value: Decimal.parse((rng.nextDouble() * 500).roundToDouble().toString()),
        date: DateTime.now().subtract(Duration(days: daysAgo)),
        tags: TagsSelection(
          primary: Tag(name: "Test 😊"),
          secondaries: [
            Tag(name: "Small 🏐"),
            Tag(name: "Big 🚀"),
          ],
        ),
        notes: 'Transaction $i',
      );
    });
  }

  Future<List<Transaction>> getByRange(TimeRange range) async {
    return _allTransactions
        .where((t) => t.date.isBefore(range.from) && t.date.isAfter(range.to))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  void create(Transaction transaction) {}

  void update(Transaction transaction) {}
}
