import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static const _themeModeKey = 'themeMode';
  static const _lastRecurringSetupKey = 'lastRecurringSetup';
  static const _currencyKey = 'currency';

  SharedPreferences? _prefs;
  ThemeMode _themeMode = ThemeMode.system;
  DateTime? _lastRecurringSetup;
  Currency _currency = Currency.euro;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    _prefs?.setInt(_themeModeKey, mode.index);
    notifyListeners();
  }

  Currency get currency => _currency;

  set currency(Currency value) {
    if (_currency == value) return;
    _currency = value;
    _prefs?.setInt(_currencyKey, value.index);
    notifyListeners();
  }

  DateTime? get lastRecurringSetup => _lastRecurringSetup;

  set lastRecurringSetup(DateTime? value) {
    _lastRecurringSetup = value;
    if (value != null) {
      _prefs?.setInt(_lastRecurringSetupKey, value.millisecondsSinceEpoch);
    } else {
      _prefs?.remove(_lastRecurringSetupKey);
    }
  }

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final index = _prefs!.getInt(_themeModeKey);
    _themeMode = index != null ? ThemeMode.values[index] : ThemeMode.system;
    final lastSetupMs = _prefs!.getInt(_lastRecurringSetupKey);
    _lastRecurringSetup = lastSetupMs != null
        ? DateTime.fromMillisecondsSinceEpoch(lastSetupMs)
        : null;
    final currencyIndex = _prefs!.getInt(_currencyKey);
    _currency = currencyIndex != null ? Currency.values[currencyIndex] : Currency.euro;
    notifyListeners();
  }
}