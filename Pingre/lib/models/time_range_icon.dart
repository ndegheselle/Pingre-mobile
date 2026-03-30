import 'package:flutter/material.dart';
import 'package:pingre/models/time_range.dart';

class TimeRangeIcon extends StatelessWidget {
  final TimeRangeUnit unit;
  final double size;
  final Color? color;

  const TimeRangeIcon({
    super.key,
    required this.unit,
    this.size = 24,
    this.color,
  });

  IconData get _icon {
    switch (unit) {
      case TimeRangeUnit.day:
        return Icons.today_outlined;
      case TimeRangeUnit.week:
        return Icons.view_week_outlined;
      case TimeRangeUnit.twoWeeks:
        return Icons.date_range_outlined;
      case TimeRangeUnit.month:
        return Icons.calendar_month_outlined;
      case TimeRangeUnit.quarter:
        return Icons.calendar_view_month_outlined;
      case TimeRangeUnit.year:
        return Icons.calendar_today_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      _icon,
      size: size,
      color: color ?? Theme.of(context).iconTheme.color,
    );
  }
}