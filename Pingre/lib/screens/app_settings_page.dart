import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/screens/tags/tags_page.dart';
import 'package:pingre/services/settings_service.dart';
import 'package:provider/provider.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();

    return FScaffold(
      header: FHeader.nested(
        title: const Text('Settings'),
        prefixes: [FHeaderAction.back(onPress: () => Navigator.pop(context))],
      ),
      child: Column(
        children: [
          FSelectMenuTile<ThemeMode>(
            prefix: const Icon(FIcons.sun),
            title: const Text('Theme'),
            detailsBuilder: (context, values, _) => _ThemeSquare(
              mode: values.firstOrNull ?? ThemeMode.system,
            ),
            selectControl: FMultiValueControl.lifted(
              value: {settings.themeMode},
              onChange: (values) {
                if (values.isNotEmpty) {
                  context.read<SettingsService>().setThemeMode(values.first);
                }
              },
            ),
            menu: const [
              FSelectTile.suffix(
                value: ThemeMode.system,
                title: Text('Auto'),
                prefix: _ThemeSquare(mode: ThemeMode.system),
              ),
              FSelectTile.suffix(
                value: ThemeMode.light,
                title: Text('Light'),
                prefix: _ThemeSquare(mode: ThemeMode.light),
              ),
              FSelectTile.suffix(
                value: ThemeMode.dark,
                title: Text('Dark'),
                prefix: _ThemeSquare(mode: ThemeMode.dark),
              ),
            ],
          ),
          FItem(
            prefix: const Icon(FIcons.tags),
            title: const Text('Tags'),
            suffix: const Icon(FIcons.chevronRight),
            details: const Text('Edit, create and delete'),
            onPress: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => const TagsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ThemeSquare extends StatelessWidget {
  static const _lightColor = Color(0xFFfafafa);
  static const _darkColor = Color(0xFF18181b);
  static const _size = 20.0;

  final ThemeMode mode;
  const _ThemeSquare({required this.mode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        borderRadius: context.theme.style.borderRadius,
        border: Border.all(color: context.theme.colors.border),
      ),
      child: ClipRRect(
        borderRadius: context.theme.style.borderRadius,
        child: _buildFill(),
      ),
    );
  }

  Widget _buildFill() => switch (mode) {
    ThemeMode.light => const ColoredBox(color: _lightColor),
    ThemeMode.dark => const ColoredBox(color: _darkColor),
    ThemeMode.system => CustomPaint(painter: _DiagonalSplitPainter()),
  };
}

class _DiagonalSplitPainter extends CustomPainter {
  static const _lightColor = _ThemeSquare._lightColor;
  static const _darkColor = _ThemeSquare._darkColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = _lightColor;
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(0, size.height)
        ..close(),
      paint,
    );

    paint.color = _darkColor;
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
  bool shouldRepaint(_DiagonalSplitPainter _) => false;
}
