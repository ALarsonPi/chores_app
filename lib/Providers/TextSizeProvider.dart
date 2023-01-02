import 'package:chore_app/Providers/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/constant/Settings.dart';

class TextSizeProvider extends ChangeNotifier {
  TextSize currTextSize = TextSize.SMALL;

  setCurrTextSize(TextSize textSizeToSet) async {
    currTextSize = textSizeToSet;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      Settings.textSizeString,
      Settings.getCurrTextString(currTextSize),
    );
    notifyListeners();
  }
}
