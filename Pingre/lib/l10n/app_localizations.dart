import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get navRecurring;

  /// No description provided for @navAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get navAccounts;

  /// No description provided for @navReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get navReport;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get settingsThemeAuto;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsCurrency;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get settingsLanguageAuto;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get settingsLanguageFrench;

  /// No description provided for @settingsTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get settingsTags;

  /// No description provided for @settingsTagsDetail.
  ///
  /// In en, this message translates to:
  /// **'Edit, create and delete'**
  String get settingsTagsDetail;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get actionApply;

  /// No description provided for @toastSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get toastSavedTitle;

  /// No description provided for @toastRemovedTitle.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get toastRemovedTitle;

  /// No description provided for @addTransactionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get addTransactionTooltip;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search ...'**
  String get searchHint;

  /// No description provided for @pullForMore.
  ///
  /// In en, this message translates to:
  /// **'Pull for more'**
  String get pullForMore;

  /// No description provided for @releaseForMore.
  ///
  /// In en, this message translates to:
  /// **'Release for more'**
  String get releaseForMore;

  /// No description provided for @newTransaction.
  ///
  /// In en, this message translates to:
  /// **'New transaction'**
  String get newTransaction;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get editTransaction;

  /// No description provided for @transactionDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transactionDetailTitle;

  /// No description provided for @transactionSavedDesc.
  ///
  /// In en, this message translates to:
  /// **'The transaction has been edited'**
  String get transactionSavedDesc;

  /// No description provided for @transactionRemovedDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Removed transaction'**
  String get transactionRemovedDialogTitle;

  /// No description provided for @transactionRemovedDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this transaction?'**
  String get transactionRemovedDialogBody;

  /// No description provided for @transactionRemovedDesc.
  ///
  /// In en, this message translates to:
  /// **'The transaction has been removed'**
  String get transactionRemovedDesc;

  /// No description provided for @transactionNoMoreFound.
  ///
  /// In en, this message translates to:
  /// **'No more transactions found.'**
  String get transactionNoMoreFound;

  /// No description provided for @selectTags.
  ///
  /// In en, this message translates to:
  /// **'Select tags'**
  String get selectTags;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesHint;

  /// No description provided for @tagValidationError.
  ///
  /// In en, this message translates to:
  /// **'At least one tag should be selected.'**
  String get tagValidationError;

  /// No description provided for @newRecurring.
  ///
  /// In en, this message translates to:
  /// **'New recurring transaction'**
  String get newRecurring;

  /// No description provided for @editRecurring.
  ///
  /// In en, this message translates to:
  /// **'Edit recurring transaction'**
  String get editRecurring;

  /// No description provided for @noRecurringFound.
  ///
  /// In en, this message translates to:
  /// **'No recurring transactions found'**
  String get noRecurringFound;

  /// No description provided for @recurringSavedDesc.
  ///
  /// In en, this message translates to:
  /// **'The recurring transaction has been saved'**
  String get recurringSavedDesc;

  /// No description provided for @recurringRemovedDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove recurring transaction'**
  String get recurringRemovedDialogTitle;

  /// No description provided for @recurringRemovedDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this recurring transaction?'**
  String get recurringRemovedDialogBody;

  /// No description provided for @recurringRemovedDesc.
  ///
  /// In en, this message translates to:
  /// **'The recurring transaction has been removed'**
  String get recurringRemovedDesc;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameHint;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'A name is required.'**
  String get nameRequired;

  /// No description provided for @positives.
  ///
  /// In en, this message translates to:
  /// **'Positives'**
  String get positives;

  /// No description provided for @negatives.
  ///
  /// In en, this message translates to:
  /// **'Negatives'**
  String get negatives;

  /// No description provided for @recurringTotalMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get recurringTotalMonthly;

  /// No description provided for @recurringTotalYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get recurringTotalYearly;

  /// No description provided for @recurringActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get recurringActive;

  /// No description provided for @newAccount.
  ///
  /// In en, this message translates to:
  /// **'New account'**
  String get newAccount;

  /// No description provided for @editAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit account'**
  String get editAccount;

  /// No description provided for @noAccountsFound.
  ///
  /// In en, this message translates to:
  /// **'No accounts found'**
  String get noAccountsFound;

  /// No description provided for @accountSavedDesc.
  ///
  /// In en, this message translates to:
  /// **'The account has been saved'**
  String get accountSavedDesc;

  /// No description provided for @accountRemovedDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove account'**
  String get accountRemovedDialogTitle;

  /// No description provided for @accountRemovedDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this account? This action cannot be undone.'**
  String get accountRemovedDialogBody;

  /// No description provided for @accountRemovedDesc.
  ///
  /// In en, this message translates to:
  /// **'The account has been removed'**
  String get accountRemovedDesc;

  /// No description provided for @accountTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get accountTypeHint;

  /// No description provided for @accountNameHint.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get accountNameHint;

  /// No description provided for @accountNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required.'**
  String get accountNameRequired;

  /// No description provided for @accountDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get accountDescriptionHint;

  /// No description provided for @accountTypeChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking Account'**
  String get accountTypeChecking;

  /// No description provided for @accountTypeCheckingDesc.
  ///
  /// In en, this message translates to:
  /// **'Used for daily transactions'**
  String get accountTypeCheckingDesc;

  /// No description provided for @accountTypeSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings Account'**
  String get accountTypeSavings;

  /// No description provided for @accountTypeSavingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Used to save money with interest'**
  String get accountTypeSavingsDesc;

  /// No description provided for @accountTypeCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get accountTypeCreditCard;

  /// No description provided for @accountTypeCreditCardDesc.
  ///
  /// In en, this message translates to:
  /// **'Borrowed money for purchases'**
  String get accountTypeCreditCardDesc;

  /// No description provided for @accountTypeCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get accountTypeCash;

  /// No description provided for @accountTypeCashDesc.
  ///
  /// In en, this message translates to:
  /// **'Physical money'**
  String get accountTypeCashDesc;

  /// No description provided for @accountTypeInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investment Account'**
  String get accountTypeInvestment;

  /// No description provided for @accountTypeInvestmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Stocks, bonds, etc.'**
  String get accountTypeInvestmentDesc;

  /// No description provided for @accountTypeLoan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get accountTypeLoan;

  /// No description provided for @accountTypeLoanDesc.
  ///
  /// In en, this message translates to:
  /// **'Borrowed money to repay'**
  String get accountTypeLoanDesc;

  /// No description provided for @accountTypeMortgage.
  ///
  /// In en, this message translates to:
  /// **'Mortgage'**
  String get accountTypeMortgage;

  /// No description provided for @accountTypeMortgageDesc.
  ///
  /// In en, this message translates to:
  /// **'Loan for real estate'**
  String get accountTypeMortgageDesc;

  /// No description provided for @tagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tagsTitle;

  /// No description provided for @noTags.
  ///
  /// In en, this message translates to:
  /// **'No tags'**
  String get noTags;

  /// No description provided for @noTagsFound.
  ///
  /// In en, this message translates to:
  /// **'No tags found'**
  String get noTagsFound;

  /// No description provided for @noExistingTag.
  ///
  /// In en, this message translates to:
  /// **'No existing tag'**
  String get noExistingTag;

  /// No description provided for @editTag.
  ///
  /// In en, this message translates to:
  /// **'Edit tag'**
  String get editTag;

  /// No description provided for @selectTagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Select tags'**
  String get selectTagsTitle;

  /// No description provided for @longPressForPrimary.
  ///
  /// In en, this message translates to:
  /// **'Long press to set primary tag'**
  String get longPressForPrimary;

  /// No description provided for @tagSavedDesc.
  ///
  /// In en, this message translates to:
  /// **'The tag has been edited'**
  String get tagSavedDesc;

  /// No description provided for @tagRemovedDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove tag'**
  String get tagRemovedDialogTitle;

  /// No description provided for @tagRemovedDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this tag? This action cannot be undone.'**
  String get tagRemovedDialogBody;

  /// No description provided for @tagRemovedDesc.
  ///
  /// In en, this message translates to:
  /// **'The tag has been removed'**
  String get tagRemovedDesc;

  /// No description provided for @tagNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get tagNameLabel;

  /// No description provided for @tagSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Tag name ...'**
  String get tagSearchHint;

  /// No description provided for @reportView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get reportView;

  /// No description provided for @reportViewPrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get reportViewPrimary;

  /// No description provided for @reportViewPrimaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Group by primary tag'**
  String get reportViewPrimaryDesc;

  /// No description provided for @reportViewAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get reportViewAll;

  /// No description provided for @reportViewAllDesc.
  ///
  /// In en, this message translates to:
  /// **'Group by tag (with duplicates)'**
  String get reportViewAllDesc;

  /// No description provided for @reportFiltersTooltip.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get reportFiltersTooltip;

  /// No description provided for @reportExportTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get reportExportTooltip;

  /// No description provided for @reportExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Exported'**
  String get reportExportSuccess;

  /// No description provided for @reportFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get reportFiltersTitle;

  /// No description provided for @reportTransactionTypeSection.
  ///
  /// In en, this message translates to:
  /// **'Transaction type'**
  String get reportTransactionTypeSection;

  /// No description provided for @reportTransactionTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get reportTransactionTypeLabel;

  /// No description provided for @reportExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get reportExpenses;

  /// No description provided for @reportIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get reportIncome;

  /// No description provided for @reportTagsSection.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get reportTagsSection;

  /// No description provided for @reportSearchTagsHint.
  ///
  /// In en, this message translates to:
  /// **'Search tags ...'**
  String get reportSearchTagsHint;

  /// No description provided for @reportNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions in this period'**
  String get reportNoTransactions;

  /// No description provided for @reportNoTransactionsForTag.
  ///
  /// In en, this message translates to:
  /// **'No transactions for this tag'**
  String get reportNoTransactionsForTag;

  /// No description provided for @timeRangeDay.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get timeRangeDay;

  /// No description provided for @timeRangeWeek.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get timeRangeWeek;

  /// No description provided for @timeRangeTwoWeeks.
  ///
  /// In en, this message translates to:
  /// **'2 weeks'**
  String get timeRangeTwoWeeks;

  /// No description provided for @timeRangeMonth.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get timeRangeMonth;

  /// No description provided for @timeRangeQuarter.
  ///
  /// In en, this message translates to:
  /// **'quarter'**
  String get timeRangeQuarter;

  /// No description provided for @timeRangeYear.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get timeRangeYear;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
