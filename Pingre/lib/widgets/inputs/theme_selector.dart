import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/services/theme_service.dart';
import 'package:provider/provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            _ThemeSquare(
              mode: ThemeMode.system,
              selected: themeService.themeMode == ThemeMode.system,
              onTap: () => themeService.setThemeMode(ThemeMode.system),
            ),
            _ThemeSquare(
              mode: ThemeMode.light,
              selected: themeService.themeMode == ThemeMode.light,
              onTap: () => themeService.setThemeMode(ThemeMode.light),
            ),
            _ThemeSquare(
              mode: ThemeMode.dark,
              selected: themeService.themeMode == ThemeMode.dark,
              onTap: () => themeService.setThemeMode(ThemeMode.dark),
            ),
          ],
        );
      },
    );
  }
}

class _ThemeSquare extends StatelessWidget {
  static const _lightColor = Color(0xFFfafafa);
  static const _darkColor = Color(0xFF18181b);
  static const _size = 28.0;
  static const _radius = 6.0;

  final ThemeMode mode;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeSquare({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final borderColor = selected ? primaryColor : FTheme.of(context).colorScheme.border;
    final borderWidth = selected ? 2.0 : 1.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_radius),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_radius - borderWidth),
          child: _buildFill(),
        ),
      ),
    );
  }

  Widget _buildFill() => switch (mode) {
    ThemeMode.light => ColoredBox(color: _lightColor),
    ThemeMode.dark => ColoredBox(color: _darkColor),
    ThemeMode.system => CustomPaint(
      painter: _DiagonalSplitPainter(
        lightColor: _lightColor,
        darkColor: _darkColor,
      ),
    ),
  };
}

class _DiagonalSplitPainter extends CustomPainter {
  final Color lightColor;
  final Color darkColor;

  const _DiagonalSplitPainter({required this.lightColor, required this.darkColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Light half: top-right triangle
    paint.color = lightColor;
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(0, size.height)
        ..close(),
      paint,
    );

    // Dark half: bottom-right triangle
    paint.color = darkColor;
    canvas.drawPath(
      Path()
        ..moveTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close(),
      paint,
    );
  }

  @override
  bool shouldRepaint(_DiagonalSplitPainter old) =>
      lightColor != old.lightColor || darkColor != old.darkColor;
}
