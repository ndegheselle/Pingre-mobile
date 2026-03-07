/// Represent a range of time
enum TimeRangeUnit { day, week, twoWeeks, month, quarter, year }

/// Represent a range of time to [to] one date in the past [from] a date in the future (to today)
class TimeRange {
  final DateTime from;
  final DateTime to;

  TimeRange({required this.from, required this.to});

  /// Returns the previous range
  TimeRange previous(TimeRangeUnit unit) =>
      TimeRange.fromUnit(unit, to.subtract(Duration(days: 1)));

  /// Create a time range from an [unit]
  static TimeRange fromUnit(TimeRangeUnit unit, [DateTime? now]) {
    final base = now ?? DateTime.now();
    final today = DateTime(base.year, base.month, base.day);
    switch (unit) {
      case TimeRangeUnit.day:
        return TimeRange(
          from: today,
          to: today.subtract(const Duration(days: 1)),
        );
      case TimeRangeUnit.week:
        return TimeRange(
          from: today,
          to: today.subtract(Duration(days: base.weekday - 1)),
        );
      case TimeRangeUnit.twoWeeks:
        return TimeRange(
          from: today,
          to: today.subtract(Duration(days: base.weekday - 1 + 7)),
        );
      case TimeRangeUnit.month:
        return TimeRange(from: today, to: today.substractMonths(1));
      case TimeRangeUnit.quarter:
        // Two last quarters
        return TimeRange(from: today, to: today.substractMonths(3));
      case TimeRangeUnit.year:
        // Current year
        return TimeRange(from: today, to: DateTime(today.year - 1, 1, 1));
    }
  }
}

extension TimeRangeUnitLabel on TimeRangeUnit {
  String get label {
    switch (this) {
      case TimeRangeUnit.day:       return 'day';
      case TimeRangeUnit.week:      return 'week';
      case TimeRangeUnit.twoWeeks:  return '2 weeks';
      case TimeRangeUnit.month:     return 'month';
      case TimeRangeUnit.quarter:   return 'quarter';
      case TimeRangeUnit.year:      return 'year';
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