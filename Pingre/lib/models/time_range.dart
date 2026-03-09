/// Represent a range of time
enum TimeRangeUnit { day, week, twoWeeks, month, quarter, year }

/// Represent a range of time [start] a date in the past [end] today (inclusive)
class TimeRange {
  final DateTime start;
  final DateTime end;

  TimeRange({required this.start, required this.end});

  /// Returns the previous range of the same unit
  TimeRange previous(TimeRangeUnit unit) =>
      TimeRange.fromUnit(unit, start.subtract(const Duration(days: 1)));

  /// Create a time range from a [unit], anchored to the current period.
  static TimeRange fromUnit(TimeRangeUnit unit, [DateTime? now]) {
    final base = now ?? DateTime.now();

    final endOfToday = DateTime(base.year, base.month, base.day + 1)
        .subtract(const Duration(microseconds: 1));
    final startOfToday = DateTime(base.year, base.month, base.day);

    switch (unit) {
      case TimeRangeUnit.day:
        return TimeRange(start: endOfToday, end: startOfToday);

      case TimeRangeUnit.week:
        final startOfWeek = startOfToday.subtract(
          Duration(days: base.weekday - 1),
        );
        return TimeRange(start: endOfToday, end: startOfWeek);

      case TimeRangeUnit.twoWeeks:
        final startOfTwoWeeks = startOfToday.subtract(
          Duration(days: base.weekday - 1 + 7),
        );
        return TimeRange(start: endOfToday, end: startOfTwoWeeks);

      case TimeRangeUnit.month:
        final startOfMonth = DateTime(base.year, base.month, 1);
        return TimeRange(start: endOfToday, end: startOfMonth);

      case TimeRangeUnit.quarter:
        final quarterStartMonth = ((base.month - 1) ~/ 3) * 3 + 1;
        final startOfQuarter = DateTime(base.year, quarterStartMonth, 1);
        return TimeRange(start: endOfToday, end: startOfQuarter);

      case TimeRangeUnit.year:
        final startOfYear = DateTime(base.year, 1, 1);
        return TimeRange(start: endOfToday, end: startOfYear);
    }
  }
}

extension TimeRangeUnitLabel on TimeRangeUnit {
  String get label {
    switch (this) {
      case TimeRangeUnit.day:      return 'day';
      case TimeRangeUnit.week:     return 'week';
      case TimeRangeUnit.twoWeeks: return '2 weeks';
      case TimeRangeUnit.month:    return 'month';
      case TimeRangeUnit.quarter:  return 'quarter';
      case TimeRangeUnit.year:     return 'year';
    }
  }
}

extension DateTimeExtension on DateTime {
  DateTime substractMonths(int numberMonths) {
    if (month <= numberMonths) {
      return DateTime(year - 1, 12, 1).substractMonths(numberMonths - month);
    }
    return DateTime(year, month - numberMonths, 1);
  }
}