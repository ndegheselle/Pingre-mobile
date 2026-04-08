import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/features/accounts/screens/accounts_page.dart';
import 'package:pingre/features/settings/screens/app_settings_page.dart';
import 'package:pingre/features/recurring/screens/recurring_page.dart';
import 'package:pingre/features/reports/screens/report_page.dart';
import 'package:pingre/features/transactions/screens/transaction_edit.dart';
import 'package:pingre/features/transactions/screens/transactions_page.dart';

final contents = [
  const TransactionsPage(),
  const RecurringPage(),
  const AccountsPage(),
  const ReportsPage(),
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
        title: const Text('Recurring'),
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
    ];

    return Stack(
      children: [
        FScaffold(
          childPad: false,
          header: headers[_index],
          footer: FBottomNavigationBar(
            index: _index,
            onChange: (index) => setState(() {
              if (index == 2) return;
              if (index > 2) {
                _index = index - 1;
              } else {
                _index = index;
              }
            }),
            children: const [
              FBottomNavigationBarItem(
                icon: Icon(FIcons.coins),
                label: Text('Transactions'),
              ),
              FBottomNavigationBarItem(
                icon: Icon(FIcons.calendarSync),
                label: Text('Recurring'),
              ),
              // Spacing for the add transaction button
              SizedBox(),
              FBottomNavigationBarItem(
                icon: Icon(FIcons.piggyBank),
                label: Text('Accounts'),
              ),
              FBottomNavigationBarItem(
                icon: Icon(FIcons.chartNoAxesCombined),
                label: Text('Report'),
              ),
            ],
          ),
          child: contents[_index],
        ),

        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: FTooltip(
              tipBuilder: (context, _) => const Text('Add transaction'),
              child: SizedBox(
                width: 64,
                height: 64,
                child: ElevatedButton(
                  onPressed: () => showTransactionEdit(context),
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
