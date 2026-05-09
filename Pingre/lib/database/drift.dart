import 'dart:io';

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
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 3) {
        await m.createTable(settingsTable);
      }
      if (from < 4) {
        await m.addColumn(recurringTransactionsTable, recurringTransactionsTable.isActive);
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

  /// Copies the current database file to the specified [targetPath].
  Future<Uint8List> backup() async {
    final dir = await getApplicationSupportDirectory();
    final dbFile = File('${dir.path}/pingre.db.sqlite');
    return await dbFile.readAsBytes();
  }

  /// Closes the database connection and replaces the database file with the one at [sourcePath].
  Future<void> restore(String sourcePath) async {
    await close();
    final dir = await getApplicationSupportDirectory();
    final dbFile = File('${dir.path}/pingre.db.sqlite');
    await File(sourcePath).copy(dbFile.path);
  }
}
