import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:forui/forui.dart';
import 'package:pingre/database/drift.dart';
import 'package:pingre/features/accounts/services/accounts.dart';
import 'package:pingre/features/recurring/services/recurring.dart';
import 'package:pingre/features/tags/services/tags.dart';
import 'package:pingre/features/settings/services/settings.dart';
import 'package:pingre/features/transactions/services/transactions.dart';
import 'package:pingre/l10n/app_localizations.dart';
import 'package:pingre/themes.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsService = SettingsService();
  await settingsService.load();

  final db = AppDatabase();

  // Tags must be initialized first — other services resolve tags from its cache.
  final tagsService = TagsService(db);
  await tagsService.initialize();

  final accountsService = AccountsService(db);
  await accountsService.initialize();

  final transactionsService = TransactionsService(db, tagsService);

  final recurringTransactionsService =
      RecurringTransactionsService(db, tagsService);
  await recurringTransactionsService.initialize();

  // Non-blocking: apply any recurring transactions missed since last open,
  // then record the timestamp so the next launch can pick up from here.
  recurringTransactionsService
      .applyMissedRecurring(transactionsService, settingsService.lastRecurringSetup)
      .then((_) => settingsService.lastRecurringSetup = DateTime.now());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: accountsService),
      ChangeNotifierProvider.value(value: tagsService),
      ChangeNotifierProvider.value(value: transactionsService),
      ChangeNotifierProvider.value(value: recurringTransactionsService),
      ChangeNotifierProvider.value(value: settingsService),
      // add more services here
    ],
    child: const Application(),
  ));
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    final themeMode = settings.themeMode;

    final light = buildPingreLight();
    final dark = buildPingreDark();

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
