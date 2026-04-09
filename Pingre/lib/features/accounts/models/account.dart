import 'package:decimal/decimal.dart';
import 'package:isar/isar.dart';
import 'package:pingre/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

enum AccountType {
  checking,
  savings,
  creditCard,
  cash,
  investment,
  loan,
  mortgage;
}

extension AccountTypeL10n on AccountType {
  String localizedName(AppLocalizations l10n) => switch (this) {
    AccountType.checking => l10n.accountTypeChecking,
    AccountType.savings => l10n.accountTypeSavings,
    AccountType.creditCard => l10n.accountTypeCreditCard,
    AccountType.cash => l10n.accountTypeCash,
    AccountType.investment => l10n.accountTypeInvestment,
    AccountType.loan => l10n.accountTypeLoan,
    AccountType.mortgage => l10n.accountTypeMortgage,
  };

  String localizedDescription(AppLocalizations l10n) => switch (this) {
    AccountType.checking => l10n.accountTypeCheckingDesc,
    AccountType.savings => l10n.accountTypeSavingsDesc,
    AccountType.creditCard => l10n.accountTypeCreditCardDesc,
    AccountType.cash => l10n.accountTypeCashDesc,
    AccountType.investment => l10n.accountTypeInvestmentDesc,
    AccountType.loan => l10n.accountTypeLoanDesc,
    AccountType.mortgage => l10n.accountTypeMortgageDesc,
  };
}

/// An account to keep track of where the money is
@collection
class Account {
  final int id;
  final String name;
  final String description;
  final AccountType type;
  final Decimal balance;

  Account({
    required this.name,
    required this.description,
    required this.type,
    required this.balance,
    int? id
  }) : id = id ?? Isar.autoIncrement;

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
