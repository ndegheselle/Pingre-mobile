import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static const _themeModeKey = 'themeMode';

  SharedPreferences? _prefs;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    _prefs?.setInt(_themeModeKey, mode.index);
    notifyListeners();
  }

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final index = _prefs!.getInt(_themeModeKey);
    _themeMode = index != null ? ThemeMode.values[index] : ThemeMode.system;
    notifyListeners();
  }
}