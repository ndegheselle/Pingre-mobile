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

  /// Returns a consistent snapshot of the database as raw bytes.
  ///
  /// Drift runs SQLite in WAL mode, so recent writes may still live in the
  /// `-wal` sidecar file and not yet be in the main `.sqlite` file. We force a
  /// full checkpoint first so the main file is complete and self-contained
  /// before reading it.
  Future<Uint8List> backup() async {
    await customStatement('PRAGMA wal_checkpoint(TRUNCATE)');
    final dir = await getApplicationSupportDirectory();
    final dbFile = File('${dir.path}/pingre.db.sqlite');
    return await dbFile.readAsBytes();
  }

  /// Closes the database connection and replaces the database file with the one
  /// at [sourcePath].
  ///
  /// The stale `-wal` and `-shm` sidecar files are deleted as well; leaving them
  /// in place would let SQLite replay the old WAL on top of the freshly restored
  /// file, corrupting or overwriting the restored data. The caller is expected
  /// to restart the app afterwards.
  Future<void> restore(String sourcePath) async {
    await close();
    final dir = await getApplicationSupportDirectory();
    final dbPath = '${dir.path}/pingre.db.sqlite';

    for (final suffix in const ['-wal', '-shm']) {
      final sidecar = File('$dbPath$suffix');
      if (await sidecar.exists()) {
        await sidecar.delete();
      }
    }

    await File(sourcePath).copy(dbPath);
  }
}
