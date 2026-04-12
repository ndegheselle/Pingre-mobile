import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/database/drift.dart';

enum Currency {
  dollar,
  euro,
  georgianLari,
  indianRupee,
  japaneseYen,
  philippinePeso,
  poundSterling,
  russianRuble,
  saudiRiyal,
  swissFranc,
  turkishLira;

  IconData get icon => switch (this) {
    dollar => FIcons.dollarSign,
    euro => FIcons.euro,
    georgianLari => FIcons.georgianLari,
    indianRupee => FIcons.indianRupee,
    japaneseYen => FIcons.japaneseYen,
    philippinePeso => FIcons.philippinePeso,
    poundSterling => FIcons.poundSterling,
    russianRuble => FIcons.russianRuble,
    saudiRiyal => FIcons.saudiRiyal,
    swissFranc => FIcons.swissFranc,
    turkishLira => FIcons.turkishLira,
  };

  String get label => switch (this) {
    dollar => 'Dollar',
    euro => 'Euro',
    georgianLari => 'Georgian Lari',
    indianRupee => 'Indian Rupee',
    japaneseYen => 'Japanese Yen',
    philippinePeso => 'Philippine Peso',
    poundSterling => 'Pound Sterling',
    russianRuble => 'Russian Ruble',
    saudiRiyal => 'Saudi Riyal',
    swissFranc => 'Swiss Franc',
    turkishLira => 'Turkish Lira',
  };
}

class SettingsService extends ChangeNotifier {
  static const _settingsId = 1;

  final AppDatabase _db;
  ThemeMode _themeMode = ThemeMode.system;
  DateTime? _lastRecurringSetup;
  Currency _currency = Currency.euro;
  Locale? _locale;

  SettingsService(this._db);

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    _save();
    notifyListeners();
  }

  Currency get currency => _currency;

  set currency(Currency value) {
    if (_currency == value) return;
    _currency = value;
    _save();
    notifyListeners();
  }

  Locale? get locale => _locale;

  set locale(Locale? value) {
    if (_locale == value) return;
    _locale = value;
    _save();
    notifyListeners();
  }

  DateTime? get lastRecurringSetup => _lastRecurringSetup;

  set lastRecurringSetup(DateTime? value) {
    _lastRecurringSetup = value;
    _save();
  }

  Future<void> load() async {
    final row = await (_db.select(_db.settingsTable)
          ..where((t) => t.id.equals(_settingsId)))
        .getSingleOrNull();
    if (row != null) {
      _themeMode = ThemeMode.values[row.themeMode];
      _lastRecurringSetup = row.lastRecurringSetup != null
          ? DateTime.fromMillisecondsSinceEpoch(row.lastRecurringSetup!)
          : null;
      _currency = Currency.values[row.currency];
      _locale = row.locale != null ? Locale(row.locale!) : null;
    }
    notifyListeners();
  }

  void _save() {
    _db.into(_db.settingsTable).insertOnConflictUpdate(
      SettingsTableCompanion(
        id: const Value(_settingsId),
        themeMode: Value(_themeMode.index),
        lastRecurringSetup: Value(_lastRecurringSetup?.millisecondsSinceEpoch),
        currency: Value(_currency.index),
        locale: Value(_locale?.languageCode),
      ),
    );
  }
}
