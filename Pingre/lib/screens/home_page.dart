import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/screens/app_settings_page.dart';
import 'package:pingre/screens/settings/settings_page.dart';
import 'package:pingre/screens/transactions/create/transaction_create_page.dart';
import 'package:pingre/screens/transactions/transactions_page.dart';

final contents = [
  const TransactionsPage(),
  const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [Text('Categories Placeholder')],
  ),
  const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [Text('Search Placeholder')],
  ),
  const SettingsPage(),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  void openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => const AppSettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headers = [
      FHeader(
        title: const Text('Transactions'),
        suffixes: [
          FHeaderAction(
            icon: const Icon(FIcons.settings),
            onPress: openSettings,
          ),
        ],
      ),
      FHeader(
        title: const Text('Accounts'),
        suffixes: [
          FHeaderAction(
            icon: const Icon(FIcons.settings),
            onPress: openSettings,
          ),
        ],
      ),
      FHeader(
        title: const Text('Report'),
        suffixes: [
          FHeaderAction(
            icon: const Icon(FIcons.settings),
            onPress: openSettings,
          ),
        ],
      ),
      FHeader(
        title: const Text('Tags'),
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
                icon: Icon(FIcons.coins),
                label: Text('Transactions'),
              ),
              FBottomNavigationBarItem(
                icon: Icon(FIcons.piggyBank),
                label: Text('Accounts'),
              ),
              FBottomNavigationBarItem(
                icon: Icon(FIcons.chartNoAxesCombined),
                label: Text('Report'),
              ),
              FBottomNavigationBarItem(
                icon: Icon(FIcons.tags),
                label: Text('Tags'),
              ),
            ],
          ),
          child: contents[_index],
        ),

        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: FTooltip(
              tipBuilder: (context, _) => const Text('Add transaction'),
              child: SizedBox(
                width: 64,
                height: 64,
                child: ElevatedButton(
                  onPressed: () => showFSheet(
                    context: context,
                    side: .btt,
                    builder: (context) => const TransactionCreatePage(),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(FIcons.plus, size: 24),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
