import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:pingre/features/accounts/models/account.dart';

class AccountsService extends ChangeNotifier {
  final Map<String, Account> accountsMap = {};
  Iterable<Account> get accounts => accountsMap.values;

  AccountsService() {
    _initializeTestAccounts();
  }

  void _initializeTestAccounts() {
    List<Account> testAccounts = [
      Account(
        id: "1",
        name: "Checking Account",
        description: "Main checking account",
        type: AccountType.checking,
        balance: Decimal.parse("1500.00"),
      ),
      Account(
        id: "2",
        name: "Savings Account",
        description: "Emergency fund savings account",
        type: AccountType.savings,
        balance: Decimal.parse("5000.00"),
      ),
      Account(
        id: "3",
        name: "Credit Card",
        description: "Visa credit card",
        type: AccountType.creditCard,
        balance: Decimal.parse("-200.00"),
      ),
    ];

    for (var account in testAccounts) {
      create(account);
    }
  }

  /// Create a tag if it doesn't exist.
  Account create(Account account) {
    accountsMap[account.id] = account;
    notifyListeners();
    return account;
  }

  Iterable<Account> search(String name) {
    return accounts.where(
      (t) => t.name.toLowerCase().contains(name.trim().toLowerCase()),
    );
  }

  void update(
    String id, {
    String? name,
    String? description,
    AccountType? type,
    Decimal? balance,
  }) {
    if (!accountsMap.containsKey(id)) return;

    accountsMap[id] = accountsMap[id]!.copyWith(
      name: name,
      description: description,
      type: type,
      balance: balance,
    );
    notifyListeners();
  }

  void remove(String id) {
    accountsMap.remove(id);
    notifyListeners();
  }
}
