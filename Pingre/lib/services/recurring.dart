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
        if (!transactionsService.existsByDateAndPrimaryTag(
          date,
          recurring.transaction.tags.primary,
        )) {
          transactionsService.create(recurring.transaction.copyWith(date: date));
        }
      }
    }
  }

  /// Returns every occurrence of [recurring] that falls strictly after [from]
  /// and on or before [to], based on the recurrence period.
  List<DateTime> _getOccurrencesBetween(
    RecurringTransaction recurring,
    DateTime from,
    DateTime to,
  ) {
    final occurrences = <DateTime>[];
    var current = recurring.transaction.date;

    // Advance anchor to the first occurrence strictly after `from`
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
