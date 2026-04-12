// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navRecurring => 'Recurring';

  @override
  String get navAccounts => 'Accounts';

  @override
  String get navReport => 'Report';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeAuto => 'Auto';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsCurrency => 'Currency';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageAuto => 'Auto';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageFrench => 'French';

  @override
  String get settingsTags => 'Tags';

  @override
  String get settingsTagsDetail => 'Edit, create and delete';

  @override
  String get actionSave => 'Save';

  @override
  String get actionRemove => 'Remove';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionApply => 'Apply';

  @override
  String get toastSavedTitle => 'Saved';

  @override
  String get toastRemovedTitle => 'Removed';

  @override
  String get addTransactionTooltip => 'Add transaction';

  @override
  String get searchHint => 'Search ...';

  @override
  String get pullForMore => 'Pull for more';

  @override
  String get releaseForMore => 'Release for more';

  @override
  String get newTransaction => 'New transaction';

  @override
  String get editTransaction => 'Edit transaction';

  @override
  String get transactionDetailTitle => 'Transaction';

  @override
  String get transactionSavedDesc => 'The transaction has been edited';

  @override
  String get transactionRemovedDialogTitle => 'Removed transaction';

  @override
  String get transactionRemovedDialogBody =>
      'Are you sure you want to remove this transaction?';

  @override
  String get transactionRemovedDesc => 'The transaction has been removed';

  @override
  String get transactionNoMoreFound => 'No more transactions found.';

  @override
  String get selectTags => 'Select tags';

  @override
  String get notesHint => 'Notes';

  @override
  String get tagValidationError => 'At least one tag should be selected.';

  @override
  String get newRecurring => 'New recurring transaction';

  @override
  String get editRecurring => 'Edit recurring transaction';

  @override
  String get noRecurringFound => 'No recurring transactions found';

  @override
  String get recurringSavedDesc => 'The recurring transaction has been saved';

  @override
  String get recurringRemovedDialogTitle => 'Remove recurring transaction';

  @override
  String get recurringRemovedDialogBody =>
      'Are you sure you want to remove this recurring transaction?';

  @override
  String get recurringRemovedDesc =>
      'The recurring transaction has been removed';

  @override
  String get nameHint => 'Name';

  @override
  String get nameRequired => 'A name is required.';

  @override
  String get positives => 'Positives';

  @override
  String get negatives => 'Negatives';

  @override
  String get recurringTotalMonthly => 'Monthly';

  @override
  String get recurringTotalYearly => 'Yearly';

  @override
  String get recurringActive => 'Active';

  @override
  String get newAccount => 'New account';

  @override
  String get editAccount => 'Edit account';

  @override
  String get noAccountsFound => 'No accounts found';

  @override
  String get accountSavedDesc => 'The account has been saved';

  @override
  String get accountRemovedDialogTitle => 'Remove account';

  @override
  String get accountRemovedDialogBody =>
      'Are you sure you want to remove this account? This action cannot be undone.';

  @override
  String get accountRemovedDesc => 'The account has been removed';

  @override
  String get accountTypeHint => 'Type';

  @override
  String get accountNameHint => 'Name';

  @override
  String get accountNameRequired => 'Name is required.';

  @override
  String get accountDescriptionHint => 'Description';

  @override
  String get accountTypeChecking => 'Checking Account';

  @override
  String get accountTypeCheckingDesc => 'Used for daily transactions';

  @override
  String get accountTypeSavings => 'Savings Account';

  @override
  String get accountTypeSavingsDesc => 'Used to save money with interest';

  @override
  String get accountTypeCreditCard => 'Credit Card';

  @override
  String get accountTypeCreditCardDesc => 'Borrowed money for purchases';

  @override
  String get accountTypeCash => 'Cash';

  @override
  String get accountTypeCashDesc => 'Physical money';

  @override
  String get accountTypeInvestment => 'Investment Account';

  @override
  String get accountTypeInvestmentDesc => 'Stocks, bonds, etc.';

  @override
  String get accountTypeLoan => 'Loan';

  @override
  String get accountTypeLoanDesc => 'Borrowed money to repay';

  @override
  String get accountTypeMortgage => 'Mortgage';

  @override
  String get accountTypeMortgageDesc => 'Loan for real estate';

  @override
  String get tagsTitle => 'Tags';

  @override
  String get noTags => 'No tags';

  @override
  String get noTagsFound => 'No tags found';

  @override
  String get noExistingTag => 'No existing tag';

  @override
  String get editTag => 'Edit tag';

  @override
  String get selectTagsTitle => 'Select tags';

  @override
  String get longPressForPrimary => 'Long press to set primary tag';

  @override
  String get tagSavedDesc => 'The tag has been edited';

  @override
  String get tagRemovedDialogTitle => 'Remove tag';

  @override
  String get tagRemovedDialogBody =>
      'Are you sure you want to remove this tag? This action cannot be undone.';

  @override
  String get tagRemovedDesc => 'The tag has been removed';

  @override
  String get tagNameLabel => 'Name';

  @override
  String get tagSearchHint => 'Tag name ...';

  @override
  String get reportView => 'View';

  @override
  String get reportViewPrimary => 'Primary';

  @override
  String get reportViewPrimaryDesc => 'Group by primary tag';

  @override
  String get reportViewAll => 'All';

  @override
  String get reportViewAllDesc => 'Group by tag (with duplicates)';

  @override
  String get reportFiltersTooltip => 'Filters';

  @override
  String get reportExportTooltip => 'Export';

  @override
  String get reportExportSuccess => 'Exported';

  @override
  String get reportFiltersTitle => 'Filters';

  @override
  String get reportTransactionTypeSection => 'Transaction type';

  @override
  String get reportTransactionTypeLabel => 'Transaction Type';

  @override
  String get reportExpenses => 'Expenses';

  @override
  String get reportIncome => 'Income';

  @override
  String get reportTagsSection => 'Tags';

  @override
  String get reportSearchTagsHint => 'Search tags ...';

  @override
  String get reportNoTransactions => 'No transactions in this period';

  @override
  String get reportNoTransactionsForTag => 'No transactions for this tag';

  @override
  String get timeRangeDay => 'day';

  @override
  String get timeRangeWeek => 'week';

  @override
  String get timeRangeTwoWeeks => '2 weeks';

  @override
  String get timeRangeMonth => 'month';

  @override
  String get timeRangeQuarter => 'quarter';

  @override
  String get timeRangeYear => 'year';
}
