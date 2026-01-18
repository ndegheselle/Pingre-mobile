import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) => FScaffold(
    header: FHeader.nested(
      title: const Text('Settings'),
      prefixes: [FHeaderAction.back(onPress: () => Navigator.pop(context))],
    ),
    child: const Text("Some content"),
  );
}