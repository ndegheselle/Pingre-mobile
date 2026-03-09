import 'package:decimal/decimal.dart';
import 'package:pingre/models/time_range.dart';
import 'package:pingre/services/transactions.dart';

class TransactionGroup {
  late final String name;
  final TimeRangeUnit unit;
  final TimeRange range;
  final List<Transaction> transactions;
  Decimal total;

  TransactionGroup({
    required this.unit,
    required this.range,
    List<Transaction>? items,
  }) : transactions = items ?? [],
       total = .zero {
    name = getName(unit, range);
  }

  TransactionGroup.fromDate({
    required this.unit,
    DateTime? now,
    List<Transaction>? items,
  }) : transactions = items ?? [],
       total = .zero,
       range = .fromUnit(unit, now) {
    name = getName(unit, range);
  }

  /// Create the previous transaction group
  TransactionGroup previous() {
    return TransactionGroup(unit: unit, range: range.previous(unit));
  }

  void add(Transaction transaction) {
    transactions.add(transaction);
    total += transaction.value;
  }

  /// Get the name of the group based on the [unit] and the time [range]
  static String getName(TimeRangeUnit unit, TimeRange range) {
    final now = DateTime.now();

    // Helper to check if the range is current
    bool isCurrent(TimeRangeUnit unit, TimeRange range) {
      switch (unit) {
        case TimeRangeUnit.day:
          return range.start.day == now.day &&
              range.start.month == now.month &&
              range.start.year == now.year;
        case TimeRangeUnit.week:
        case TimeRangeUnit.twoWeeks:
          // Check if the range includes today
          return now.isBefore(range.start) && now.isAfter(range.end);
        case TimeRangeUnit.month:
        case TimeRangeUnit.quarter:
          return range.start.month == now.month && range.start.year == now.year;
        case TimeRangeUnit.year:
          return range.start.year == now.year;
      }
    }

    // Helper to check if the range is last
    bool isLast(TimeRangeUnit unit, TimeRange range) {
      switch (unit) {
        case TimeRangeUnit.day:
          final yesterday = now.subtract(const Duration(days: 1));
          return range.start.day == yesterday.day &&
              range.start.month == yesterday.month &&
              range.start.year == yesterday.year;
        case TimeRangeUnit.week:
        case TimeRangeUnit.twoWeeks:
          // Check if the range is the previous week
          final lastWeekStart = now.subtract(
            Duration(days: now.weekday - 1 + 7),
          );
          final lastWeekEnd = now.subtract(Duration(days: now.weekday - 1 + 1));
          return lastWeekStart.isBefore(range.start) && lastWeekEnd.isAfter(range.end);
        case TimeRangeUnit.month:
        case TimeRangeUnit.quarter:
          final lastMonth = now.month == 1 ? 12 : now.month - 1;
          final lastMonthYear = now.month == 1 ? now.year - 1 : now.year;
          return range.start.month == lastMonth &&
              range.start.year == lastMonthYear;
        case TimeRangeUnit.year:
          return range.start.year == now.year - 1;
      }
    }

    // Format helper
    String formatDate(DateTime d) {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[d.month - 1]} ${d.day}';
    }

    if (isCurrent(unit, range)) {
      return 'Current ${unit.label}';
    } else if (isLast(unit, range)) {
      return 'Last ${unit.label}';
    }

    // Original logic for other cases
    switch (unit) {
      case TimeRangeUnit.day:
        return formatDate(range.start);
      case TimeRangeUnit.week:
      case TimeRangeUnit.twoWeeks:
        return '${formatDate(range.start)} - ${formatDate(range.end)}';
      case TimeRangeUnit.month:
      case TimeRangeUnit.quarter:
        const months = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];
        final label = months[range.start.month - 1];
        return range.start.year != now.year
            ? '$label ${range.start.year}'
            : label;
      case TimeRangeUnit.year:
        return '${range.start.year}';
    }
  }
}

extension TransactionGroupExtension on Iterable<TransactionGroup> {
  /// Get the whole range of the list of group.
  TimeRange range() {
    if (isEmpty) return TimeRange(start: DateTime.now(), end: DateTime.now());
    return TimeRange(start: first.range.start, end: last.range.end);
  }

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

extension TransactionsExtension on List<Transaction> {
  /// Group transactions in transactions groups with empty group between transactions, [this] must me sorted by date.
  List<TransactionGroup> groupByUnit(TimeRangeUnit unit, [DateTime? now]) {
    if (isEmpty) return [];

    List<TransactionGroup> groups = [];
    TransactionGroup currentGroup = .fromDate(unit: unit, now: now);
    for (var transaction in this) {
      while (transaction.date.isBefore(currentGroup.range.end)) {
        groups.add(currentGroup);
        currentGroup = currentGroup.previous();
      }
      currentGroup.add(transaction);
    }

    groups.add(currentGroup);
    return groups;
  }
}
