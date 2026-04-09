import 'package:decimal/decimal.dart';
import 'package:uuid/uuid.dart';

enum AccountType {
  checking('Checking Account', 'Used for daily transactions'),
  savings('Savings Account', 'Used to save money with interest'),
  creditCard('Credit Card', 'Borrowed money for purchases'),
  cash('Cash', 'Physical money'),
  investment('Investment Account', 'Stocks, bonds, etc.'),
  loan('Loan', 'Borrowed money to repay'),
  mortgage('Mortgage', 'Loan for real estate');

  final String name;
  final String description;

  const AccountType(this.name, this.description);
}

/// An account to keep track of where the money is
class Account {
  final String id;
  final String name;
  final String description;
  final AccountType type;
  final Decimal balance;

  Account({
    required this.name,
    required this.description,
    required this.type,
    required this.balance,
    String? id
  }) : id = id ?? const Uuid().v4();

  Account copyWith({
    String? name,
    String? description,
    AccountType? type,
    Decimal? balance,
  }) {
    return Account(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      balance: balance ?? this.balance,
    );
  }
}
