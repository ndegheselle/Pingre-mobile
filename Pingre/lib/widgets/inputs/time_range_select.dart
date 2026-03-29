import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/models/time_range.dart';

class TimeRangeSelect extends StatefulWidget {
  final TimeRangeUnit value;
  final ValueChanged<TimeRangeUnit>? onChanged;
  const TimeRangeSelect({super.key, required this.value, this.onChanged});

  @override
  State<TimeRangeSelect> createState() => _TimeRangeSelectState();
}

class _TimeRangeSelectState extends State<TimeRangeSelect> {
  static const _items = <(TimeRangeUnit, String)>[
    (TimeRangeUnit.day, 'D'),
    (TimeRangeUnit.week, 'W'),
    (TimeRangeUnit.twoWeeks, '2W'),
    (TimeRangeUnit.month, 'M'),
    (TimeRangeUnit.quarter, '3M'),
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

  void _setSelected(TimeRangeUnit value, int index) {
    setState(() {
      _selectedValue = value;
      _selectedIndex = index;
    });
    widget.onChanged?.call(value);
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
                      onTap: () => _setSelected(item.$1, index),
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
