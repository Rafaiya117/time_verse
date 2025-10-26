import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; 

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
  }

  //!-------- Method to switch between light and dark modes --------------!
  void toggleTheme() {
    if (_themeMode == ThemeMode.light || _themeMode == ThemeMode.system && WidgetsBinding.instance.window.platformBrightness == Brightness.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }
}