import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool value) {
    if (_isDarkMode == value) return;

    _isDarkMode = value;
    notifyListeners();
  }
}

final themeController = ThemeController();
