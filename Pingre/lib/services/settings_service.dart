import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  ThemeMode? _themeMode;

  ThemeMode get themeMode {
    if (_themeMode == null) {
      _themeMode = ThemeMode.system;
      _getPreference<int>('themeMode').then((value) {
        if (value != null) {
          _themeMode = ThemeMode.values[value];
          notifyListeners();
        }
      });
    }
    return _themeMode!;
  }

  set themeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
  }

  Future<T?> _getPreference<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key) as T?;
  }
}
