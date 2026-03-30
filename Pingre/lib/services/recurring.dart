import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:pingre/models/time_range.dart';
import 'package:pingre/services/tags.dart';
import 'package:pingre/services/transactions.dart';
import 'package:uuid/uuid.dart';

class RecurringTransaction {
  final String id;
  final String name;
  final Transaction transaction;
  final TimeRangeUnit range;

  RecurringTransaction({
    required this.name,
    required this.transaction,
    required this.range,
    String? id,
  }) : id = id ?? const Uuid().v4();

  RecurringTransaction copyWith({
    String? id,
    String? name,
    Transaction? transaction,
    TimeRangeUnit? range,
  }) {
    return RecurringTransaction(
      id: id ?? this.id,
      name: name ?? this.name,
      transaction: transaction ?? this.transaction,
      range: range ?? this.range,
    );
  }
}

class RecurringTransactionsService extends ChangeNotifier {
  final Map<String, RecurringTransaction> _recurringTransactionsMap = {};

  Iterable<RecurringTransaction> get recurringTransactions =>
      _recurringTransactionsMap.values;

  RecurringTransactionsService() {
    _initializeTestRecurringTransactions();
  }

  void _initializeTestRecurringTransactions() {
    List<RecurringTransaction> testRecurringTransactions = [
      RecurringTransaction(
        id: "1",
        name: "Monthly Rent",
        transaction: Transaction(
          value: Decimal.parse("-1200.00"),
          date: DateTime.now(),
          tags: TagsSelection(
            primary: Tag(name: "Pouet 🏠"),
            secondaries: [Tag(name: "Fafa 🏐")],
          ),
        ),
        range: TimeRangeUnit.month,
      ),
    ];

    for (var recurringTransaction in testRecurringTransactions) {
      create(recurringTransaction);
    }
  }

  RecurringTransaction create(RecurringTransaction recurringTransaction) {
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

  void update(
    String id, {
    String? name,
    Transaction? transaction,
    TimeRangeUnit? range,
  }) {
    if (!_recurringTransactionsMap.containsKey(id)) return;
    _recurringTransactionsMap[id] = _recurringTransactionsMap[id]!.copyWith(
      transaction: transaction,
      range: range,
      name: name,
    );
    notifyListeners();
  }

  void remove(String id) {
    _recurringTransactionsMap.remove(id);
    notifyListeners();
  }
}
