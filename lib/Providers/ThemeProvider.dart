import 'package:flutter/material.dart';

import '../ColorControl/AppColors.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode selectedThemeMode = ThemeMode.light;
  Color selectedPrimaryColor = AppColors.primaryColorList[0];

  setSelectedPrimaryColor(Color _color) {
    selectedPrimaryColor = _color;
    notifyListeners();
  }

  setSelectedThemeMode(ThemeMode _themeMode) {
    selectedThemeMode = _themeMode;
    notifyListeners();
  }
}
