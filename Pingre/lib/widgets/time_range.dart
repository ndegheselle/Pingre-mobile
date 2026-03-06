import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

enum TimeRangeUnit { day, week, twoWeeks, month, threeMonths, year }

class TimeRange {
  final DateTime start;
  final DateTime end;

  TimeRange({required this.start, required this.end});

  /// Returns the NEXT range (older data = going back in time)
  TimeRange previous(TimeRangeUnit unit) {
    switch (unit) {
      case TimeRangeUnit.day:
        return TimeRange(
          start: start.subtract(const Duration(days: 1)),
          end: start.subtract(const Duration(microseconds: 1)),
        );
      case TimeRangeUnit.week:
        return TimeRange(
          start: start.subtract(const Duration(days: 7)),
          end: start.subtract(const Duration(microseconds: 1)),
        );
      case TimeRangeUnit.month:
        final newMonth = start.month == 1 ? 12 : start.month - 1;
        final newYear = start.month == 1 ? start.year - 1 : start.year;
        return TimeRange(
          start: DateTime(newYear, newMonth, 1),
          end: start.subtract(const Duration(microseconds: 1)),
        );
      case TimeRangeUnit.year:
        return TimeRange(
          start: DateTime(start.year - 1, 1, 1),
          end: start.subtract(const Duration(microseconds: 1)),
        );
    }
  }

  /// Factory: build the CURRENT range containing [now]
  static TimeRange current(TimeRangeUnit unit, [DateTime? now]) {
    final base = now ?? DateTime.now();
    switch (unit) {
      case TimeRangeUnit.day:
        final start = DateTime(base.year, base.month, base.day);
        return TimeRange(start: start, end: start.add(const Duration(days: 1, microseconds: -1)));
      case TimeRangeUnit.week:
        final start = base.subtract(Duration(days: base.weekday - 1));
        final s = DateTime(start.year, start.month, start.day);
        return TimeRange(start: s, end: s.add(const Duration(days: 7, microseconds: -1)));
      case TimeRangeUnit.month:
        final start = DateTime(base.year, base.month, 1);
        return TimeRange(
          start: start,
          end: DateTime(base.year, base.month + 1, 1).subtract(const Duration(microseconds: 1)),
        );
      case TimeRangeUnit.year:
        final start = DateTime(base.year, 1, 1);
        return TimeRange(
          start: start,
          end: DateTime(base.year + 1, 1, 1).subtract(const Duration(microseconds: 1)),
        );
    }
  }

  String label(TimeRangeUnit unit) {
    switch (unit) {
      case TimeRangeUnit.day:
        return '${start.day}/${start.month}/${start.year}';
      case TimeRangeUnit.week:
        return 'Week of ${start.day}/${start.month}';
      case TimeRangeUnit.month:
        const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
        return '${months[start.month - 1]} ${start.year}';
      case TimeRangeUnit.year:
        return '${start.year}';
    }
  }
}


class TimeRangeSelector extends StatefulWidget {
  final TimeRangeUnit value;
  const TimeRangeSelector({super.key, required this.value});

  @override
  State<TimeRangeSelector> createState() => _TimeRangeSelectorState();
}

class _TimeRangeSelectorState extends State<TimeRangeSelector> {
  static const _items = <(TimeRangeUnit, String)>[
    (TimeRangeUnit.day, 'D'),
    (TimeRangeUnit.week, 'W'),
    (TimeRangeUnit.twoWeeks, '2W'),
    (TimeRangeUnit.month, 'M'),
    (TimeRangeUnit.threeMonths, '3M'),
    (TimeRangeUnit.year, 'Y'),
  ];
  static const padding = EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0);

  late TimeRangeUnit _selectedValue;
  int _selectedIndex = 0;
  final List<GlobalKey> _itemKeys = List.generate(
    _items.length,
    (_) => GlobalKey(),
  );

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
    _selectedIndex = _items.indexWhere((item) => item.$1 == _selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colors.secondary,
        borderRadius: theme.style.borderRadius,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = (constraints.maxWidth) / _items.length;
          return Stack(
            children: [
              // Animated sweeping background
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                left: _selectedIndex * itemWidth,
                top: 0,
                bottom: 0,
                child: Container(
                  width: itemWidth,
                  decoration: BoxDecoration(
                    color: theme.colors.background,
                    borderRadius: theme.style.borderRadius,
                  ),
                ),
              ),
              // Items
              Row(
                mainAxisSize: MainAxisSize.min,
                children: _items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = index == _selectedIndex;

                  return Expanded(
                    child: GestureDetector(
                      key: _itemKeys[index],
                      onTap: () {
                        setState(() {
                          _selectedValue = item.$1;
                          _selectedIndex = index;
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            style: theme.typography.base.copyWith(
                              color: isSelected
                                  ? theme.colors.foreground
                                  : theme.colors.mutedForeground,
                            ),
                            child: Text(item.$2),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
