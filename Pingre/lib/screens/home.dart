import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/screens/settings.dart';

final contents = [
  const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [Text('Home Placeholder')],
  ),
  const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [Text('Categories Placeholder')],
  ),
  const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [Text('Search Placeholder')],
  ),
  const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [Text('Settings Placeholder')],
  ),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 3;

  void openSettings() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => const SettingsPage()));
  }

  @override
  Widget build(BuildContext context) {
    final headers = [
      FHeader.nested(
        prefixes: const [Icon(FIcons.piggyBank)],
        title: const Text('Accounts'),
        suffixes: [
          FHeaderAction(
            icon: const Icon(FIcons.settings),
            onPress: openSettings,
          ),
        ],
      ),
      FHeader.nested(
        prefixes: const [Icon(FIcons.chartNoAxesCombined)],
        title: const Text('Stats'),
        suffixes: [
          FHeaderAction(
            icon: const Icon(FIcons.settings),
            onPress: openSettings,
          ),
        ],
      ),
      FHeader.nested(
        prefixes: const [Icon(FIcons.calendar1)],
        title: const Text('Recurrent'),
        suffixes: [
          FHeaderAction(
            icon: const Icon(FIcons.settings),
            onPress: openSettings,
          ),
        ],
      ),
      FHeader.nested(
        prefixes: const [Icon(FIcons.tags)],
        title: const Text('Categories'),
        suffixes: [
          FHeaderAction(
            icon: const Icon(FIcons.settings),
            onPress: openSettings,
          ),
        ],
      ),
    ];

    return Stack(
      children: [
        FScaffold(
          header: headers[_index],
          footer: FBottomNavigationBar(
            index: _index,
            onChange: (index) => setState(() => _index = index),
            children: const [
              FBottomNavigationBarItem(
                icon: Icon(FIcons.piggyBank),
                label: Text('Accounts'),
              ),
              FBottomNavigationBarItem(
                icon: Icon(FIcons.chartNoAxesCombined),
                label: Text('Stats'),
              ),
              FBottomNavigationBarItem(
                icon: Icon(FIcons.calendar1),
                label: Text('Recurrent'),
              ),
              FBottomNavigationBarItem(
                icon: Icon(FIcons.tags),
                label: Text('Categories'),
              ),
            ],
          ),
          child: contents[_index],
        ),

        Positioned(
          bottom: 48,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              width: 64,
              height: 64,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                ),
                child: const Icon(FIcons.plus, size: 24),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
