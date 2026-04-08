import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static const _themeModeKey = 'themeMode';
  static const _lastRecurringSetupKey = 'lastRecurringSetup';

  SharedPreferences? _prefs;
  ThemeMode _themeMode = ThemeMode.system;
  DateTime? _lastRecurringSetup;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    _prefs?.setInt(_themeModeKey, mode.index);
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
    notifyListeners();
  }
}