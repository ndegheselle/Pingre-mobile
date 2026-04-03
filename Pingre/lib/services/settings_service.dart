import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static SharedPreferences? _prefs;

  ThemeMode? _themeMode;

  ThemeMode get themeMode => _themeMode ?? ThemeMode.system;

  set themeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await _prefs?.setInt('themeMode', mode.index);
  }

  Future<void> load() async {
    _prefs ??= await SharedPreferences.getInstance();
    final saved = _getPreference<int>('themeMode');
    if (saved != null) _themeMode = ThemeMode.values[saved];
    notifyListeners();
  }

  T? _getPreference<T>(String key) => _prefs?.get(key) as T?;
}
