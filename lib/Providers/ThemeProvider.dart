import 'package:flutter/material.dart';

import '../ColorControl/AppColors.dart';
import '../Global.dart';

import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode selectedThemeMode = ThemeMode.light;
  Color selectedPrimaryColor = AppColors.primaryColorList[0];
  bool isDarkMode = false;

  setSelectedPrimaryColor(Color color) {
    selectedPrimaryColor = color;
    setCircleThemeColor();

    notifyListeners();
  }

  setSelectedThemeMode(ThemeMode themeMode) {
    selectedThemeMode = themeMode;
    setIsDarkMode();
    setCircleThemeColor();

    notifyListeners();
  }

  setIsDarkMode() {
    isDarkMode = (selectedThemeMode == ThemeMode.dark);
  }

  setCircleThemeColor() {
    Global.currentTheme = (isDarkMode)
        ? AppColors.darkModeThemeColorList[Global.currPrimaryColorIndex]
        : AppColors.themeColorList[Global.currPrimaryColorIndex];
  }
}
