import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

enum TimeRange { day, week, twoWeeks, month, threeMonths, year }

class TimeRangeSegmentedControl extends StatefulWidget {
  final TimeRange value;
  final ValueChanged<TimeRange> onChanged;

  const TimeRangeSegmentedControl({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<TimeRangeSegmentedControl> createState() =>
      _TimeRangeSegmentedControlState();
}

class _TimeRangeSegmentedControlState extends State<TimeRangeSegmentedControl> {
  static const _items = <(TimeRange, String)>[
    (TimeRange.day, 'D'),
    (TimeRange.week, 'W'),
    (TimeRange.twoWeeks, '2W'),
    (TimeRange.month, 'M'),
    (TimeRange.threeMonths, '3M'),
    (TimeRange.year, 'Y'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: theme.style.borderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _items.map((item) {
          final isSelected = widget.value == item.$1;

          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onChanged(item.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: theme.style.borderRadius,
                  color: isSelected
                    ? Colors.green
                    : Colors.transparent,
                ),
                child: Center(child: Text(item.$2)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
