import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'screens/home_page.dart';

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: FLocalizations.supportedLocales,
      localizationsDelegates: const [...FLocalizations.localizationsDelegates],

      theme: FThemes.neutral.light.toApproximateMaterialTheme(),
      darkTheme: FThemes.neutral.dark.toApproximateMaterialTheme(),
      // Uses system brightness automatically
      themeMode: ThemeMode.system,

      builder: (context, child) {
        /// Wrap with FAnimatedTheme so Forui widgets get animated theme changes
        final brightness = MediaQuery.of(context).platformBrightness;
        final theme = brightness == Brightness.dark
            ? FThemes.neutral.dark
            : FThemes.neutral.light;

        return FTheme(
          data: theme,
          child: FToaster(child: FTooltipGroup(child: child!)),
        );
      },

      home: const FScaffold(child: HomePage()),
    );
  }
}
