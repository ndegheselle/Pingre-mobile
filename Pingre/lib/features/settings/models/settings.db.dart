import 'package:drift/drift.dart';

class SettingsTable extends Table {
  IntColumn get id => integer()();
  IntColumn get themeMode => integer().withDefault(const Constant(0))();
  IntColumn get lastRecurringSetup => integer().nullable()();
  IntColumn get currency => integer().withDefault(const Constant(1))();
  TextColumn get locale => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
