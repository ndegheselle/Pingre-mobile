import 'package:decimal/decimal.dart';
import 'package:pingre/models/time_range.dart';
import 'package:pingre/services/transactions.dart';

class TransactionGroup {
  late final String name;
  final TimeRange range;
  final List<Transaction> transactions;
  Decimal total;

  TransactionGroup({required this.range, List<Transaction>? items})
    : transactions = items ?? [],
      total = .zero {
    name = range.getName();
  }

  bool get isEmpty => transactions.isEmpty;

  /// Create the previous transaction group
  TransactionGroup previous() => TransactionGroup(range: range.previous());

  void add(Transaction transaction) {
    transactions.add(transaction);
    total += transaction.value;
  }
}

extension TransactionGroupExtension on Iterable<TransactionGroup> {
  /// Fill the transactions of a list of transactions group.
  void fill(Iterable<Transaction> transactions) {
    for (var transaction in transactions) {
      final transactionDate = transaction.date;
      // Find the group whose range contains the transaction date
      for (var group in this) {
        if (transactionDate.isBefore(
              group.range.start.add(const Duration(days: 1)),
            ) &&
            transactionDate.isAfter(
              group.range.end.subtract(const Duration(days: 1)),
            )) {
          group.add(transaction);
          break; // No need to check other groups
        }
      }
    }
  }
}

/// Convenience methods for grouping and processing lists of [Transaction]s, the list must be sorted by date.
extension TransactionsExtension on List<Transaction> {
  /// Group transactions in transactions groups with empty group between transactions.
  List<TransactionGroup> groupByUnit(TimeRangeUnit unit, {DateTime? now}) {
    if (isEmpty) return [];

    List<TransactionGroup> groups = [];
    TransactionGroup currentGroup = TransactionGroup(
      range: .current(unit, now),
    );
    for (var transaction in this) {
      while (transaction.date.isBefore(currentGroup.range.start)) {
        if (currentGroup.transactions.isNotEmpty) {
          groups.add(currentGroup);
        }
        currentGroup = currentGroup.previous();
      }
      currentGroup.add(transaction);
    }

    groups.add(currentGroup);
    return groups;
  }

  /// Adds a transaction to the given [existingGroup] and creates new groups if needed.
  ///
  /// Returns the newly created [TransactionGroup]s. The provided [existingGroup]
  /// is updated but is **not included** in the returned list.
  List<TransactionGroup> continueToGroupFrom(TransactionGroup existingGroup) {
    if (isEmpty) return [];

    List<TransactionGroup> groups = [];
    TransactionGroup currentGroup = existingGroup;
    for (var transaction in this) {
      while (transaction.date.isBefore(currentGroup.range.start)) {
        if (currentGroup.transactions.isNotEmpty) {
          groups.add(currentGroup);
        }
        currentGroup = currentGroup.previous();
      }
      currentGroup.add(transaction);
    }

    groups.add(currentGroup);
    return groups;
  }
}
