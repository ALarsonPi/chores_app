import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/constant/Settings.dart';

class TextSizeProvider extends ChangeNotifier {
  TextSize currTextSize = TextSize.MEDIUM;
  double fontSizeToAdd = 0;

  void setFontSizeToAdd() {
    if (currTextSize == TextSize.LARGE) {
      fontSizeToAdd = 6;
    } else if (currTextSize == TextSize.MEDIUM) {
      fontSizeToAdd = 3;
    } else {
      fontSizeToAdd = 0;
    }
  }

  void setCurrTextSize(TextSize textSizeToSet) async {
    currTextSize = textSizeToSet;
    setFontSizeToAdd();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      Settings.textSizeString,
      Settings.getCurrTextString(currTextSize),
    );
    notifyListeners();
  }
}
