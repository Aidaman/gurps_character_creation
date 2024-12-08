import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _currentTheme = ThemeMode.system;

  ThemeMode get currentTheme => _currentTheme;
  set currentTheme(ThemeMode? value) {
    if (value == null) {
      return;
    }

    _currentTheme = value;
    notifyListeners();
  }
}
