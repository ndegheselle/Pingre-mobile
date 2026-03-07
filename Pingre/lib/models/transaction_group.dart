import 'package:decimal/decimal.dart';
import 'package:pingre/models/time_range.dart';
import 'package:pingre/services/transactions.dart';

class TransactionGroup {
  final TimeRange range;
  final String name;
  final List<Transaction> transactions;
  Decimal total;

  TransactionGroup({
    required this.range,
    required this.name,
    List<Transaction>? items,
  }) : transactions = items ?? [], total = .zero;

  void add(Transaction transaction)
  {
    transactions.add(transaction);
    total += transaction.value;
  }

  /// Number of ranges to create for each unit to time.
  static const Map<TimeRangeUnit, int> numberOfRanges = {
    TimeRangeUnit.day: 10,
    TimeRangeUnit.week: 4,
    TimeRangeUnit.twoWeeks: 2,
    TimeRangeUnit.month: 3,
    TimeRangeUnit.quarter: 2,
    TimeRangeUnit.year: 1,
  };

  /// Get the name of the group based on the [unit], the time [range] and the [index] of the group?
  static String getName(TimeRangeUnit unit, TimeRange range, int index) {
    if (index == 0) return 'Current ${unit.label}';
    if (index == 1) return 'Last ${unit.label}';

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

    switch (unit) {
      case TimeRangeUnit.day:
        // e.g. "Mar 5"
        return formatDate(range.from);

      case TimeRangeUnit.week:
      case TimeRangeUnit.twoWeeks:
        // e.g. "Feb 6 - Feb 13"
        return '${formatDate(range.from)} - ${formatDate(range.to)}';

      case TimeRangeUnit.month:
      case TimeRangeUnit.quarter:
        // e.g. "Feb 2025" or just "Feb" if same year
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
        final now = DateTime.now();
        final label = months[range.from.month - 1];
        return range.from.year != now.year
            ? '$label ${range.from.year}'
            : label;

      case TimeRangeUnit.year:
        return '${range.from.year}';
    }
  }

  /// Create empty groupes based on the [unit] and the [numberOfRanges].
  static List<TransactionGroup> empty(TimeRangeUnit unit, [DateTime? now]) {
    int number = numberOfRanges[unit]!;

    var range = TimeRange.fromUnit(unit, now);
    List<TransactionGroup> groupes = [];
    for (int i = 0; i < number; i++) {
      groupes.add(
        TransactionGroup(range: range, name: getName(unit, range, i)),
      );
      range = range.previous(unit);
    }
    return groupes;
  }
}

extension TransactionGroupExtension on Iterable<TransactionGroup> {

  /// Get the whole range of the list of group.
  TimeRange range()
  {
    if (isEmpty) return TimeRange(from: DateTime.now(), to: DateTime.now());
    return TimeRange(from: first.range.from, to: last.range.to);
  }

  /// Fill the transactions of a list of transactions group.
  void fill(Iterable<Transaction> transactions) {
    for (var transaction in transactions) {
      final transactionDate = transaction.date;
      // Find the group whose range contains the transaction date
      for (var group in this) {
        if (transactionDate.isBefore(
              group.range.from.add(const Duration(days: 1)),
            ) && transactionDate.isAfter(
              group.range.to.subtract(const Duration(days: 1)),
            )) {
          group.add(transaction);
          break; // No need to check other groups
        }
      }
    }
  }
}
