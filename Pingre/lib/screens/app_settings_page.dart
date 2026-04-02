import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/screens/tags/tags_page.dart';
import 'package:pingre/widgets/inputs/theme_selector.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) => FScaffold(
    header: FHeader.nested(
      title: const Text('Settings'),
      prefixes: [FHeaderAction.back(onPress: () => Navigator.pop(context))],
    ),
    child: FItemGroup(
      children: [
        FItem(
          prefix: const Icon(FIcons.sun),
          title: const Text('Theme'),
          suffix: const ThemeSelector(),
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
