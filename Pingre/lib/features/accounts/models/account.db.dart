import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:pingre/database/drift.dart';
import 'package:pingre/features/accounts/models/account.dart';

class AccountsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get type => text()(); // store enum as string
  TextColumn get balance => text()(); // store Decimal as string
  
  @override
  Set<Column> get primaryKey => {id};
}

extension AccountMapper on Account {
  // Domain → DB row (Drift generates AccountsTableData)
  AccountsTableData toData() => AccountsTableData(
    id: id,
    name: name,
    description: description,
    type: type.name,                  // enum → string
    balance: balance.toString(),      // Decimal → string
  );
  
  // DB row → Domain model (static factory)
  static Account fromData(AccountsTableData data) => Account(
    id: data.id,
    name: data.name,
    description: data.description,
    type: AccountType.values.byName(data.type),
    balance: Decimal.parse(data.balance),
  );
}