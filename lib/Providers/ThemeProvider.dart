import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ColorControl/AppColors.dart';
import '../Global.dart';

class ThemeProvider with ChangeNotifier {
  bool isDarkMode = (Global.settings.darkModeIndex != 0);
  ThemeMode selectedThemeMode =
      (Global.settings.darkModeIndex == 0) ? ThemeMode.light : ThemeMode.dark;
  Color selectedPrimaryColor =
      AppColors.primaryColorList[Global.settings.primaryColorIndex];

  setSelectedPrimaryColor(Color color) async {
    selectedPrimaryColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(Settings.primaryColorString,
        AppColors.primaryColorList.indexOf(selectedPrimaryColor));
    setCircleThemeColor();

    notifyListeners();
  }

  setSelectedThemeMode(ThemeMode themeMode) {
    selectedThemeMode = themeMode;
    setIsDarkMode();
    setCircleThemeColor();

    notifyListeners();
  }

  setIsDarkMode() async {
    isDarkMode = (selectedThemeMode == ThemeMode.dark);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(Settings.darkModeString, (isDarkMode) ? 1 : 0);
  }

  setCircleThemeColor() {
    Global.currentTheme = (isDarkMode)
        ? AppColors.darkModeThemeColorList[Global.currPrimaryColorIndex]
        : AppColors.themeColorList[Global.currPrimaryColorIndex];
  }
}
