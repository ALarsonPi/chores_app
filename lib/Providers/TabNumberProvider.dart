import 'package:flutter/cupertino.dart';

class TabNumberProvider extends ChangeNotifier {
  int numTabs = 2;

  changeNumTabs(String tabType) {
    tabType = tabType.toLowerCase();
    if (tabType == "one") {
      numTabs = 1;
    } else if (tabType == "two") {
      numTabs = 2;
    } else if (tabType == "three") {
      numTabs = 3;
    }
    debugPrint(tabType);
    notifyListeners();
  }

  changeNumTabsByInt(int desiredNumTabs) {
    numTabs = desiredNumTabs;
    debugPrint(desiredNumTabs.toString());
    notifyListeners();
  }
}
