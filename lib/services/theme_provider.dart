import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;
  ThemeProvider(this._themeData);

  ThemeData getTheme() => _themeData;
  
  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}