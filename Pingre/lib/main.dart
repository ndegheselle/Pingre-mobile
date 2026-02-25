import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/theme_extensions.dart';

import 'screens/home_page.dart';

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final light = FThemes.zinc.light.copyWith(
      extensions: const [
        AppSemanticColors(
          positive: Color(0xFF48c78e), // green-600
          negative: Color(0xFFff6685), // red-600
        ),
      ],
    );

    final dark = FThemes.zinc.dark.copyWith(
      extensions: const [
        AppSemanticColors(
          positive: Color(0xFF48c78e), // lighter green for dark bg
          negative: Color(0xFFff6685), // lighter red for dark bg
        ),
      ],
    );

    return MaterialApp(
      supportedLocales: FLocalizations.supportedLocales,
      localizationsDelegates: const [...FLocalizations.localizationsDelegates],

      theme: light.toApproximateMaterialTheme(),
      darkTheme: dark.toApproximateMaterialTheme(),
      // Uses system brightness automatically
      themeMode: ThemeMode.system,

      builder: (context, child) {
        final brightness = Theme.of(context).brightness;
        final theme = brightness == Brightness.dark ? dark : light;

        return FTheme(
          data: theme,
          child: FToaster(child: FTooltipGroup(child: child!)),
        );
      },

      home: const FScaffold(child: HomePage()),
    );
  }
}
