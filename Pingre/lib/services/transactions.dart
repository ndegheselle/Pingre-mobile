import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pingre/services/tags.dart';
import 'package:uuid/uuid.dart';

class TagsSelection
{
  final Tag primary;
  final List<Tag> secondaries;
  List<Tag> get all => [primary, ...secondaries];

  TagsSelection({required this.primary, List<Tag>? secondaries}) : secondaries = secondaries ?? [];
}

class Transaction {
  final String id;
  final double value;
  
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

class TransactionsService extends ChangeNotifier {

final List<Transaction> _allTransactions = _generateFakeData();

  Future<List<Transaction>> fetchByRange(TimeRange range) async {
    await Future.delayed(const Duration(milliseconds: 600)); // simulate network
    return _allTransactions
        .where((t) => !t.date.isBefore(range.start) && !t.date.isAfter(range.end))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static List<Transaction> _generateFakeData() {
    final rng = Random();
    return List.generate(200, (i) {
      final daysAgo = rng.nextInt(365);
      return Transaction(
        value: (rng.nextDouble() * 500).roundToDouble(),
        date: DateTime.now().subtract(Duration(days: daysAgo)),
        tags: TagsSelection.none(), // replace with your tags
        notes: 'Transaction $i',
      );
    });
  }

  void create(Transaction transaction)
  {

  }
  
  void update(Transaction transaction)
  {

  }
}