import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeData get lightTheme => LightTheme.theme;

  ThemeData get darkTheme => DarkTheme.theme;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light;

    notifyListeners();
  }

  void setDarkMode(bool value) {
    _themeMode =
        value ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }
}