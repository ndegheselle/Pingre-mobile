import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// A grid-based color picker.
///
/// - [initialColor] pre-selects a color when the widget is first built.
///   Pass `null` to start with no selection.
/// - [onChanged] is called every time the user taps a color circle.
///   The argument is the newly selected [Color], or `null` when the user
///   taps the already-selected color to deselect it.
/// - [colors] lets you supply a custom palette; falls back to [defaultColors].
class ColorPicker extends StatefulWidget {
  const ColorPicker({
    super.key,
    this.initialColor,
    this.onChanged,
    this.colors = defaultColors,
  });

  final Color? initialColor;
  final ValueChanged<Color?>? onChanged;

  /// The list of selectable colors.
  /// Each entry is a Dart record containing a [Color] and a display [name].
  final List<({Color color, String name})> colors;

  /// Built-in palette used when no [colors] argument is supplied.
  static const List<({Color color, String name})> defaultColors = [
    (color: Colors.red, name: 'Red'),
    (color: Colors.pink, name: 'Pink'),
    (color: Colors.purple, name: 'Purple'),
    (color: Colors.deepPurple, name: 'Deep Purple'),
    (color: Colors.indigo, name: 'Indigo'),
    (color: Colors.blue, name: 'Blue'),
    (color: Colors.lightBlue, name: 'Light Blue'),
    (color: Colors.cyan, name: 'Cyan'),
    (color: Colors.teal, name: 'Teal'),
    (color: Colors.green, name: 'Green'),
    (color: Colors.lightGreen, name: 'Light Green'),
    (color: Colors.lime, name: 'Lime'),
    (color: Colors.yellow, name: 'Yellow'),
    (color: Colors.amber, name: 'Amber'),
    (color: Colors.orange, name: 'Orange'),
    (color: Colors.deepOrange, name: 'Deep Orange'),
    (color: Colors.brown, name: 'Brown'),
    (color: Colors.grey, name: 'Grey'),
    (color: Colors.blueGrey, name: 'Blue Grey'),
  ];

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  /// Allows a parent to push a new [initialColor] after the widget is mounted.
  @override
  void didUpdateWidget(ColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialColor != widget.initialColor) {
      setState(() => _selectedColor = widget.initialColor);
    }
  }

  void _handleTap(Color? color) {
    final next = _selectedColor == color ? null : color;
    setState(() => _selectedColor = next);
    widget.onChanged?.call(next);
  }

  /// Returns black or white, whichever contrasts better with [background].
  Color _contrastColor(Color background) =>
      background.computeLuminance() > 0.35 ? Colors.black : Colors.white;

  String? get _selectedName => _selectedColor == null
      ? null
      : widget.colors
            .cast<({Color color, String name})?>()
            .firstWhere((e) => e!.color == _selectedColor, orElse: () => null)
            ?.name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      children: [
        GestureDetector(
          onTap: () => _handleTap(_selectedColor),
          child:
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 8),
                height: 32,
                decoration: BoxDecoration(
                  color: _selectedColor ?? context.theme.colors.secondary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _selectedColor != null
                      ? [
                          BoxShadow(
                            color: _selectedColor!.withAlpha(128),
                            blurRadius: 8,
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    _selectedName ?? 'Select a color',
                    style: TextStyle(
                      color: _selectedColor != null
                          ? _contrastColor(_selectedColor!)
                          : context.theme.colors.foreground,
                    ),
                  ),
                ),
              ),
        ),
        SizedBox(
          height: 40,
          width: .infinity,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(width: 4),
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: widget.colors.length,
            itemBuilder: (context, index) {
              final entry = widget.colors[index];
              final isSelected = _selectedColor == entry.color;
              return GestureDetector(
                onTap: () => _handleTap(entry.color),
                child: FTooltip(
                  tipBuilder: (context, _) => Text(entry.name),
                  child: AnimatedContainer(
                    width: 40,
                    height: 40,
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: entry.color,
                      border: Border.all(
                        color: isSelected
                            ? context.theme.colors.foreground
                            : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: entry.color.withAlpha(128),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: isSelected
                        ? Icon(
                            FIcons.check,
                            color: _contrastColor(entry.color),
                            size: 22,
                          )
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
