import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:forui/forui.dart';
import 'package:pingre/features/accounts/services/accounts.dart';
import 'package:pingre/features/recurring/services/recurring.dart';
import 'package:pingre/features/tags/services/tags.dart';
import 'package:pingre/features/settings/services/settings.dart';
import 'package:pingre/features/transactions/services/transactions.dart';
import 'package:pingre/l10n/app_localizations.dart';
import 'package:pingre/theme_extensions.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsService = SettingsService();
  await settingsService.load();

  final transactionsService = TransactionsService();
  final recurringTransactionsService = RecurringTransactionsService();

  // Non-blocking: apply any recurring transactions missed since last open,
  // then record the timestamp so the next launch can pick up from here.
  recurringTransactionsService
      .applyMissedRecurring(transactionsService, settingsService.lastRecurringSetup)
      .then((_) => settingsService.lastRecurringSetup = DateTime.now());

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountsService()),
        ChangeNotifierProvider(create: (_) => TagsService()),
        ChangeNotifierProvider.value(value: transactionsService),
        ChangeNotifierProvider.value(value: recurringTransactionsService),
        ChangeNotifierProvider.value(value: settingsService),
        // add more services here
      ],
      child: const Application(),
    ),);
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    final themeMode = settings.themeMode;

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
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        ...FLocalizations.localizationsDelegates,
      ],

      locale: settings.locale,
      theme: light.toApproximateMaterialTheme(),
      darkTheme: dark.toApproximateMaterialTheme(),
      themeMode: themeMode,

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
