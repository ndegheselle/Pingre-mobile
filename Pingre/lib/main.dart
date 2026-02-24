import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/theme/theme.dart';

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

      /// Use light and dark themes here
      theme: light.toApproximateMaterialTheme(),
      darkTheme: dark.toApproximateMaterialTheme(),
      themeMode: ThemeMode.system, // Uses system brightness automatically

      builder: (context, child) {
        /// Wrap with FAnimatedTheme so Forui widgets get animated theme changes
        final brightness = MediaQuery.of(context).platformBrightness;
        final fTheme = brightness == Brightness.dark ? dark : light;

        return FTheme(data: fTheme, child: child!);
      },

      home: const HomePage(),
    );
  }
}