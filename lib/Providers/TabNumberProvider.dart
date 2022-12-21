import 'package:chore_app/Global.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabNumberProvider extends ChangeNotifier {
  // Set in Main
  int numTabs = Global.settings.numChartsToShow;
  int currTab = 0;

  changeCurrTabNum(int newNum) {
    currTab = newNum;
    notifyListeners();
  }

  changeNumTabs(String tabType) async {
    int originalNumTabs = numTabs;
    tabType = tabType.toLowerCase();
    if (tabType == "one") {
      numTabs = 1;
    } else if (tabType == "two") {
      numTabs = 2;
    } else if (tabType == "three") {
      numTabs = 3;
    }

    currTab = numTabs;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(Settings.numChartsString, numTabs);

    notifyListeners();
  }

  changeNumTabsByInt(int desiredNumTabs) {
    numTabs = desiredNumTabs;
    notifyListeners();
  }
}
