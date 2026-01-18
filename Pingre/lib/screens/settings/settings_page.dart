import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) => FItemGroup(
  divider: FItemDivider.none,
  children: [
    FItem(
      prefix: const Icon(FIcons.user),
      title: const Text('Personalization'),
      suffix: const Icon(FIcons.chevronRight),
      onPress: () {},
    ),
    FItem(
      prefix: const Icon(FIcons.wifi),
      title: const Text('WiFi'),
      details: const Text('Duobase (5G)'),
      suffix: const Icon(FIcons.chevronRight),
      onPress: () {},
    ),
  ],
);
}
