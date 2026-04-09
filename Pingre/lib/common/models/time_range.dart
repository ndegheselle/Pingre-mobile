import 'package:intl/intl.dart';
import 'package:pingre/l10n/app_localizations.dart';

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

  /// Create a time range spanning the duration defined by [unit], anchored at either [start] or [end].
  /// Exactly one of [start] or [end] must be provided; if neither is given, [start] defaults to now.
  /// For example, with [start] = 18/02/2026 and [unit] = [TimeRangeUnit.month], you get 18/02/2026 → 18/03/2026.
  factory TimeRange.elapsed(
    TimeRangeUnit unit, {
    DateTime? start,
    DateTime? end,
  }) {
    if (start == null && end == null) end = DateTime.now();
    if (start != null && end != null) throw Exception("The start and end cannot be set together.");

    return switch (unit) {
      .day => TimeRange(
        unit: unit,
        start: (start ?? end!).toStart(),
        end: (end ?? start!).toEnd(),
      ),
      .week => TimeRange(
        unit: unit,
        start: (start ?? end!.subtract(Duration(days: 7))).toStart(),
        end: (end ?? start!.add(Duration(days: 7))).toEnd(),
      ),
      .twoWeeks => TimeRange(
        unit: unit,
        start: (start ?? end!.subtract(Duration(days: 14))).toStart(),
        end: (end ?? start!.add(Duration(days: 14))).toEnd(),
      ),
      .month => TimeRange(
        unit: unit,
        start: (start ?? end!.substractMonths(1)).toStart(),
        end: (end ?? start!.addMonths(1)).toEnd(),
      ),
      .quarter => TimeRange(
        unit: unit,
        start: (start ?? end!.substractMonths(3)).toStart(),
        end: (end ?? start!.addMonths(3)).toEnd(),
      ),
      .year => TimeRange(
        unit: unit,
        start: (start ?? end!.substractYears(1)).toStart(),
        end: (end ?? start!.addYears(1)).toEnd(),
      ),
    };
  }

  /// Create a time range from the beginning of the period defined by [unit] up to the end of the anchor date's day.
  /// Exactly one of [start] or [end] must be provided; if neither is given, the anchor defaults to now.
  /// For example, with anchor = 18/03/2026 and [unit] = [TimeRangeUnit.month], you get 01/03/2026 → 18/03/2026.
  factory TimeRange.current(TimeRangeUnit unit, {DateTime? start, DateTime? end}) {
    if (start == null && end == null) end = DateTime.now();
    if (start != null && end != null) throw Exception("The start and end cannot be set together.");

return switch (unit) {
      .day => TimeRange(
        unit: unit,
        start: (start ?? end!).toStart(),
        end: (end ?? start!).toEnd(),
      ),
      .week => TimeRange(
        unit: unit,
        start: (start ?? end!.subtract(Duration(days: end.weekday - 1))).toStart(),
        end: (end ?? start!.add(Duration(days: 7 - start.weekday))).toEnd(),
      ),
      .twoWeeks => TimeRange(
        unit: unit,
        start: (start ?? end!.subtract(Duration(days: end.weekday - 1 + 7))).toStart(),
        end: (end ?? start!.add(Duration(days: 7 - start.weekday + 7))).toEnd(),
      ),
      .month => TimeRange(
        unit: unit,
        start: (start ?? DateTime(end!.year, end.month, 1)).toStart(),
        end: (end ?? DateTime(start!.year, start.month + 1, 0)).toEnd(),
      ),
      .quarter => TimeRange(
        unit: unit,
        start: (start ?? DateTime(end!.substractMonths(3).year, end.substractMonths(3).month, 1)).toStart(),
        end: (end ?? DateTime(start!.addMonths(3).year, start.addMonths(3).month + 1, 0)).toEnd(),
      ),
      .year => TimeRange(
        unit: unit,
        start: (start ?? DateTime(end!.year, 1, 1)).toStart(),
        end: (end ?? DateTime(start!.year, 12, 31)).toEnd(),
      ),
    };
  }

  /// Returns the previous range of the same unit
  TimeRange previous() => isCurrent
      ? .current(unit, end: start.subtract(const Duration(days: 1)))
      : .elapsed(unit, end: start.subtract(const Duration(days: 1)));

  /// Returns the next range of the same unit
  TimeRange next() => isCurrent
      ? .current(unit, start: end.add(const Duration(days: 1)))
      : .elapsed(unit, start: end.add(const Duration(days: 1)));

  /// Get the display name of the group based on the [range], formatted for [locale].
  String getName(String locale) {
    switch (unit) {
      case TimeRangeUnit.day:
        return start.formatShort(locale);
      case TimeRangeUnit.week:
      case TimeRangeUnit.twoWeeks:
        return '${start.formatShort(locale)} - ${end.formatShort(locale)}';
      case TimeRangeUnit.month:
      case TimeRangeUnit.quarter:
        return start.formatShortMonth(locale);
      case TimeRangeUnit.year:
        return '${start.year}';
    }
  }
}

extension TimeRangeUnitLabel on TimeRangeUnit {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case TimeRangeUnit.day:
        return l10n.timeRangeDay;
      case TimeRangeUnit.week:
        return l10n.timeRangeWeek;
      case TimeRangeUnit.twoWeeks:
        return l10n.timeRangeTwoWeeks;
      case TimeRangeUnit.month:
        return l10n.timeRangeMonth;
      case TimeRangeUnit.quarter:
        return l10n.timeRangeQuarter;
      case TimeRangeUnit.year:
        return l10n.timeRangeYear;
    }
  }
}

extension DateTimeExtension on DateTime {

  DateTime addMonths(int numberMonths) {
    final totalMonths = month + numberMonths;
    if (totalMonths > 12) {
      return DateTime(year + 1, 1, day).addMonths(totalMonths - 13);
    }
    else if (totalMonths <= 0)
    {
      return DateTime(year - 1, 12, day).addMonths(totalMonths);
    }
    return DateTime(year, totalMonths, day);
  }
  DateTime substractMonths(int numberMonths) => addMonths(-numberMonths);

  DateTime addYears(int numberYears) => DateTime(year + numberYears, month, day);
  DateTime substractYears(int numberYears) => addYears(-numberYears);

  /// Set the hours to the start of the day (00h00)
  DateTime toStart() => DateTime(year, month, day);

  /// Set the hours to the end of the day (23h59)
  DateTime toEnd() =>
      toStart().add(Duration(days: 1)).subtract(Duration(microseconds: 1));

  String formatShort(String locale) {
    return DateFormat('d MMM', locale).format(this);
  }

  String formatWithHour(String locale) {
    final datePart = DateFormat('d MMM yyyy', locale).format(this);
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$datePart - ${h}h$m';
  }

  String formatShortMonth(String locale) {
    final label = DateFormat('MMMM', locale).format(this);
    return year != DateTime.now().year ? '$label $year' : label;
  }
}
