/// Represent a range of time
enum TimeRangeUnit { day, week, twoWeeks, month, quarter, year }

/// Represent a range of time [start] a date in the past [end] today (inclusive)
class TimeRange {
  final bool isCurrent;
  final TimeRangeUnit unit;
  final DateTime start;
  final DateTime end;

  TimeRange({
    required this.unit,
    required this.start,
    required this.end,
    this.isCurrent = false,
  });

  /// Create a time range that [end] at [now] and [start] at [now] minus the number of days defined by the [unit].
  /// For example if now is the 18/03/2026 and the unit is [TimeRangeUnit.month] you will get 18/03/2026 -> 18/02/2026.
  /// [TimeRangeUnit.day] is an exception since it will return a range for the day in [now].
  factory TimeRange.elapsed(TimeRangeUnit unit, [DateTime? now]) {
    final base = now ?? DateTime.now();

    final endOfToday = DateTime(
      base.year,
      base.month,
      base.day + 1,
    ).subtract(const Duration(microseconds: 1));
    final startOfToday = DateTime(base.year, base.month, base.day);

    switch (unit) {
      case TimeRangeUnit.day:
        return TimeRange(unit: unit, start: startOfToday, end: endOfToday);

      case TimeRangeUnit.week:
        final previousWeek = startOfToday.subtract(Duration(days: 6));
        return TimeRange(unit: unit, start: previousWeek, end: endOfToday);

      case TimeRangeUnit.twoWeeks:
        final previousTwoWeeks = startOfToday.subtract(Duration(days: 7 + 6));
        return TimeRange(unit: unit, start: previousTwoWeeks, end: endOfToday);

      case TimeRangeUnit.month:
        return TimeRange(
          unit: unit,
          start: startOfToday.substractMonths(1),
          end: endOfToday,
        );

      case TimeRangeUnit.quarter:
        return TimeRange(
          unit: unit,
          start: startOfToday.substractMonths(3),
          end: endOfToday,
        );

      case TimeRangeUnit.year:
        final previousYear = DateTime(base.year - 1, base.month, base.day);
        return TimeRange(unit: unit, start: previousYear, end: endOfToday);
    }
  }

  /// Create a time range that [end] at [now] and [start] at the begining of the period defined in [unit].
  /// For example if now is the 18/03/2026 and the unit is [TimeRangeUnit.month] you will get 18/03/2026 -> 01/03/2026.
  factory TimeRange.current(TimeRangeUnit unit, [DateTime? now]) {
    final base = now ?? DateTime.now();

    final endOfToday = DateTime(
      base.year,
      base.month,
      base.day + 1,
    ).subtract(const Duration(microseconds: 1));
    final startOfToday = DateTime(base.year, base.month, base.day);

    switch (unit) {
      case TimeRangeUnit.day:
        return TimeRange(
          unit: unit,
          start: startOfToday,
          end: endOfToday,
          isCurrent: true,
        );

      case TimeRangeUnit.week:
        final startOfWeek = startOfToday.subtract(
          Duration(days: base.weekday - 1),
        );
        return TimeRange(
          unit: unit,
          start: startOfWeek,
          end: endOfToday,
          isCurrent: true,
        );

      case TimeRangeUnit.twoWeeks:
        final startOfTwoWeeks = startOfToday.subtract(
          Duration(days: base.weekday - 1 + 7),
        );
        return TimeRange(
          unit: unit,
          start: startOfTwoWeeks,
          end: endOfToday,
          isCurrent: true,
        );

      case TimeRangeUnit.month:
        final startOfMonth = DateTime(base.year, base.month, 1);
        return TimeRange(
          unit: unit,
          start: startOfMonth,
          end: endOfToday,
          isCurrent: true,
        );

      case TimeRangeUnit.quarter:
        final quarterStartMonth = ((base.month - 1) ~/ 3) * 3 + 1;
        final startOfQuarter = DateTime(base.year, quarterStartMonth, 1);
        return TimeRange(
          unit: unit,
          start: startOfQuarter,
          end: endOfToday,
          isCurrent: true,
        );

      case TimeRangeUnit.year:
        final startOfYear = DateTime(base.year, 1, 1);
        return TimeRange(
          unit: unit,
          start: startOfYear,
          end: endOfToday,
          isCurrent: true,
        );
    }
  }

  bool get isLatest {
    final now = DateTime.now();
    return end.year == now.year &&
        end.month == now.month &&
        end.day == now.day;
  }

  /// Returns the previous range of the same unit
  TimeRange previous() => isCurrent
      ? .current(unit, start.subtract(const Duration(days: 1)))
      : .elapsed(unit, start.subtract(const Duration(days: 1)));

  /// Returns the next range of the same unit, or null if already at the latest
  TimeRange? next() {
    if (isLatest) return null;
    final nextDay = end.add(const Duration(days: 1));
    return .elapsed(unit, nextDay);
  }

  /// Get the name of the group based on the [range]
  String getName() {
    final now = DateTime.now();

    // Helper to check if the range is current
    bool isCurrent(TimeRange range) {
      switch (range.unit) {
        case TimeRangeUnit.day:
          return range.end.day == now.day &&
              range.end.month == now.month &&
              range.end.year == now.year;
        case TimeRangeUnit.week:
        case TimeRangeUnit.twoWeeks:
          // Check if the range includes today
          return now.isAfter(range.start) && now.isBefore(range.end);
        case TimeRangeUnit.month:
        case TimeRangeUnit.quarter:
          return range.end.month == now.month && range.end.year == now.year;
        case TimeRangeUnit.year:
          return range.end.year == now.year;
      }
    }

    // Original logic for other cases
    switch (unit) {
      case TimeRangeUnit.day:
        return isCurrent(this) ? 'Today' : start.formatShort();
      case TimeRangeUnit.week:
      case TimeRangeUnit.twoWeeks:
        return isCurrent(this)
            ? 'Current ${unit.label}'
            : '${start.formatShort()} - ${end.formatShort()}';
      case TimeRangeUnit.month:
      case TimeRangeUnit.quarter:
        return isCurrent(this)
            ? 'Current ${unit.label}'
            : start.formatShortMonth();
      case TimeRangeUnit.year:
        return isCurrent(this) ? 'Current ${unit.label}' : '${start.year}';
    }
  }
}

extension TimeRangeUnitLabel on TimeRangeUnit {
  String get label {
    switch (this) {
      case TimeRangeUnit.day:
        return 'day';
      case TimeRangeUnit.week:
        return 'week';
      case TimeRangeUnit.twoWeeks:
        return '2 weeks';
      case TimeRangeUnit.month:
        return 'month';
      case TimeRangeUnit.quarter:
        return 'quarter';
      case TimeRangeUnit.year:
        return 'year';
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

  String formatShort() {
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
    return '${months[month - 1]} $day';
  }

  String formatShortMonth() {
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
    final label = months[month - 1];
    return year != DateTime.now().year ? '$label $year' : label;
  }
}
