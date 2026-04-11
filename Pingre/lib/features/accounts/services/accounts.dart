import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:pingre/database/drift.dart';
import 'package:pingre/features/accounts/models/account.dart';
import 'package:pingre/features/accounts/models/account.db.dart';

class AccountsService extends ChangeNotifier {
  final AppDatabase _db;

  final Map<String, Account> accountsMap = {};
  Iterable<Account> get accounts => accountsMap.values;

  AccountsService(this._db);

  Future<void> initialize() async {
    final rows = await _db.select(_db.accountsTable).get();
    accountsMap.clear();
    for (final row in rows) {
      accountsMap[row.id] = AccountMapper.fromData(row);
    }
    notifyListeners();
  }

  Future<Account> create(Account account) async {
    await _db.into(_db.accountsTable).insert(account.toData());
    accountsMap[account.id] = account;
    notifyListeners();
    return account;
  }

  Iterable<Account> search(String name) {
    return accounts.where(
      (t) => t.name.toLowerCase().contains(name.trim().toLowerCase()),
    );
  }

  Future<void> update(
    String id, {
    String? name,
    String? description,
    AccountType? type,
    Decimal? balance,
  }) async {
    if (!accountsMap.containsKey(id)) return;
    final updated = accountsMap[id]!.copyWith(
      name: name,
      description: description,
      type: type,
      balance: balance,
    );
    await _db.update(_db.accountsTable).replace(updated.toData());
    accountsMap[id] = updated;
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await (_db.delete(_db.accountsTable)..where((t) => t.id.equals(id))).go();
    accountsMap.remove(id);
    notifyListeners();
  }
}
