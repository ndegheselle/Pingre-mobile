import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt('themeMode');
    if (value != null) {
      _themeMode = ThemeMode.values[value];
      notifyListeners();
    }
  }
}
