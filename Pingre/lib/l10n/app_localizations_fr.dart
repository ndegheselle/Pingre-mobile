// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navRecurring => 'Récurrents';

  @override
  String get navAccounts => 'Comptes';

  @override
  String get navReport => 'Rapport';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeAuto => 'Auto';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsCurrency => 'Devise';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageAuto => 'Auto';

  @override
  String get settingsLanguageEnglish => 'Anglais';

  @override
  String get settingsLanguageFrench => 'Français';

  @override
  String get settingsTags => 'Tags';

  @override
  String get settingsTagsDetail => 'Modifier, créer et supprimer';

  @override
  String get settingsBackup => 'Sauvegarde';

  @override
  String get settingsRestore => 'Restorer une sauvegarde';

  @override
  String get settingsRestoreDialogTitle =>
      'Confirmer la restauration des données';

  @override
  String get settingsRestoreDialogBody =>
      'Toute les données actuelles seront perdu, êtes vous sure de vouloir continuer ?';

  @override
  String get settingsBackupSuccess =>
      'Les données ont été sauvegarder avec succès.';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsData => 'Données';

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get actionRemove => 'Supprimer';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionConfirm => 'Confirmer';

  @override
  String get actionEdit => 'Modifier';

  @override
  String get actionApply => 'Appliquer';

  @override
  String get toastSavedTitle => 'Enregistré';

  @override
  String get toastRemovedTitle => 'Supprimé';

  @override
  String get addTransactionTooltip => 'Ajouter une transaction';

  @override
  String get searchHint => 'Rechercher ...';

  @override
  String get pullForMore => 'Tirer pour plus';

  @override
  String get releaseForMore => 'Relâcher pour charger';

  @override
  String get newTransaction => 'Nouvelle transaction';

  @override
  String get editTransaction => 'Modifier la transaction';

  @override
  String get transactionDetailTitle => 'Transaction';

  @override
  String get transactionSavedDesc => 'La transaction a été modifiée';

  @override
  String get transactionRemovedDialogTitle => 'Transaction supprimée';

  @override
  String get transactionRemovedDialogBody =>
      'Êtes-vous sûr de vouloir supprimer cette transaction ?';

  @override
  String get transactionRemovedDesc => 'La transaction a été supprimée';

  @override
  String get transactionNoMoreFound => 'Aucune transactions chargés.';

  @override
  String get selectTags => 'Sélectionner des tags';

  @override
  String get notesHint => 'Notes';

  @override
  String get tagValidationError => 'Au moins un tag doit être sélectionné.';

  @override
  String get newRecurring => 'Nouvelle transaction récurrente';

  @override
  String get editRecurring => 'Modifier la transaction récurrente';

  @override
  String get noRecurringFound => 'Aucune transaction récurrente trouvée';

  @override
  String get recurringSavedDesc =>
      'La transaction récurrente a été enregistrée';

  @override
  String get recurringRemovedDialogTitle =>
      'Supprimer la transaction récurrente';

  @override
  String get recurringRemovedDialogBody =>
      'Êtes-vous sûr de vouloir supprimer cette transaction récurrente ?';

  @override
  String get recurringRemovedDesc =>
      'La transaction récurrente a été supprimée';

  @override
  String get nameHint => 'Nom';

  @override
  String get nameRequired => 'Un nom est requis.';

  @override
  String get positives => 'Positives';

  @override
  String get negatives => 'Négatives';

  @override
  String get recurringTotalMonthly => 'Mensuel';

  @override
  String get recurringTotalYearly => 'Annuel';

  @override
  String get recurringActive => 'Actif';

  @override
  String get newAccount => 'Nouveau compte';

  @override
  String get editAccount => 'Modifier le compte';

  @override
  String get total => 'Total';

  @override
  String get noAccountsFound => 'Aucun compte trouvé';

  @override
  String get accountSavedDesc => 'Le compte a été enregistré';

  @override
  String get accountRemovedDialogTitle => 'Supprimer le compte';

  @override
  String get accountRemovedDialogBody =>
      'Êtes-vous sûr de vouloir supprimer ce compte ? Cette action est irréversible.';

  @override
  String get accountRemovedDesc => 'Le compte a été supprimé';

  @override
  String get accountTypeHint => 'Type';

  @override
  String get accountNameHint => 'Nom';

  @override
  String get accountNameRequired => 'Le nom est requis.';

  @override
  String get accountDescriptionHint => 'Description';

  @override
  String get accountTypeChecking => 'Compte courant';

  @override
  String get accountTypeCheckingDesc =>
      'Utilisé pour les transactions quotidiennes';

  @override
  String get accountTypeSavings => 'Compte épargne';

  @override
  String get accountTypeSavingsDesc =>
      'Utilisé pour épargner avec des intérêts';

  @override
  String get accountTypeCreditCard => 'Carte de crédit';

  @override
  String get accountTypeCreditCardDesc => 'Argent emprunté pour des achats';

  @override
  String get accountTypeCash => 'Espèces';

  @override
  String get accountTypeCashDesc => 'Argent physique';

  @override
  String get accountTypeInvestment => 'Compte d\'investissement';

  @override
  String get accountTypeInvestmentDesc => 'Actions, obligations, etc.';

  @override
  String get accountTypeLoan => 'Prêt';

  @override
  String get accountTypeLoanDesc => 'Argent emprunté à rembourser';

  @override
  String get accountTypeMortgage => 'Hypothèque';

  @override
  String get accountTypeMortgageDesc => 'Prêt immobilier';

  @override
  String get tagsTitle => 'Tags';

  @override
  String get noTags => 'Aucun tag';

  @override
  String get noTagsFound => 'Aucun tag trouvé';

  @override
  String get noExistingTag => 'Aucun tag existant';

  @override
  String get editTag => 'Modifier le tag';

  @override
  String get selectTagsTitle => 'Sélectionner des tags';

  @override
  String get longPressForPrimary => 'Appui long pour définir le tag principal';

  @override
  String get tagSavedDesc => 'Le tag a été modifié';

  @override
  String get tagRemovedDialogTitle => 'Supprimer le tag';

  @override
  String get tagRemovedDialogBody =>
      'Êtes-vous sûr de vouloir supprimer ce tag ? Cette action est irréversible.';

  @override
  String get tagRemovedDesc => 'Le tag a été supprimé';

  @override
  String get tagNameLabel => 'Nom';

  @override
  String get tagSearchHint => 'Nom du tag ...';

  @override
  String get reportView => 'Vue';

  @override
  String get reportViewPrimary => 'Principal';

  @override
  String get reportViewPrimaryDesc => 'Grouper par tag principal';

  @override
  String get reportViewAll => 'Tout';

  @override
  String get reportViewAllDesc => 'Grouper par tag (avec doublons)';

  @override
  String get reportFiltersTooltip => 'Filtres';

  @override
  String get reportExportTooltip => 'Exporter';

  @override
  String get reportExportSuccess => 'Exporté';

  @override
  String get reportFiltersTitle => 'Filtres';

  @override
  String get reportTransactionTypeSection => 'Type de transaction';

  @override
  String get reportTransactionTypeLabel => 'Type de transaction';

  @override
  String get reportExpenses => 'Dépenses';

  @override
  String get reportIncome => 'Revenus';

  @override
  String get reportTagsSection => 'Tags';

  @override
  String get reportSearchTagsHint => 'Rechercher des tags ...';

  @override
  String get reportNoTransactions => 'Aucune transaction sur cette période';

  @override
  String get reportNoTransactionsForTag => 'Aucune transaction pour ce tag';

  @override
  String get timeRangeDay => 'jour';

  @override
  String get timeRangeWeek => 'semaine';

  @override
  String get timeRangeTwoWeeks => '2 semaines';

  @override
  String get timeRangeMonth => 'mois';

  @override
  String get timeRangeQuarter => 'trimestre';

  @override
  String get timeRangeYear => 'an';
}
