import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/features/accounts/screens/page_accounts.dart';
import 'package:pingre/features/settings/screens/page_settings.dart';
import 'package:pingre/features/recurring/screens/page_recurring.dart';
import 'package:pingre/features/reports/screens/page_reports.dart';
import 'package:pingre/features/transactions/screens/overlay_transaction_edit.dart';
import 'package:pingre/features/transactions/screens/page_transactions.dart';
import 'package:pingre/l10n/app_localizations.dart';

final contents = [
  const PageTransactions(),
  const PageRecurring(),
  const PageAccounts(),
  const PageReports(),
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
      MaterialPageRoute<void>(builder: (context) => const PageSettings()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final headers = [
      FHeader(
        title: Text(l10n.navTransactions),
        suffixes: [
          FHeaderAction(
            icon: const Icon(FIcons.settings),
            onPress: openSettings,
          ),
        ],
      ),
      FHeader(
        title: Text(l10n.navRecurring),
        suffixes: [
          FHeaderAction(
            icon: const Icon(FIcons.settings),
            onPress: openSettings,
          ),
        ],
      ),
      FHeader(
        title: Text(l10n.navAccounts),
        suffixes: [
          FHeaderAction(
            icon: const Icon(FIcons.settings),
            onPress: openSettings,
          ),
        ],
      ),
      FHeader(
        title: Text(l10n.navReport),
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
            index: _index >= 2 ? _index + 1 : _index,
            onChange: (index) => setState(() {
              if (index == 2) return;
              if (index > 2) {
                _index = index - 1;
              } else {
                _index = index;
              }
            }),
            children: [
              FBottomNavigationBarItem(
                icon: const Icon(FIcons.coins),
                label: Text(l10n.navTransactions),
              ),
              FBottomNavigationBarItem(
                icon: const Icon(FIcons.calendarSync),
                label: Text(l10n.navRecurring),
              ),
              // Spacing for the add transaction button
              const SizedBox(),
              FBottomNavigationBarItem(
                icon: const Icon(FIcons.piggyBank),
                label: Text(l10n.navAccounts),
              ),
              FBottomNavigationBarItem(
                icon: const Icon(FIcons.chartNoAxesCombined),
                label: Text(l10n.navReport),
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
              tipBuilder: (context, _) => Text(l10n.addTransactionTooltip),
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
