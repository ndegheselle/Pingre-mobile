import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pingre/features/accounts/models/account.db.dart';
import 'package:pingre/features/tags/models/tag.db.dart';
import 'package:pingre/features/transactions/models/transaction.db.dart';
import 'package:pingre/features/recurring/models/recurring.db.dart';
import 'package:pingre/features/settings/models/settings.db.dart';

part 'drift.g.dart';

@DriftDatabase(tables: [
  AccountsTable,
  TagsTable,
  TransactionsTable,
  TransactionTagsTable,
  RecurringTransactionsTable,
  RecurringTransactionTagsTable,
  SettingsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 3) {
        await m.createTable(settingsTable);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'pingre.db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
