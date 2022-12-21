import 'package:chore_app/Global.dart';
import 'package:flutter/cupertino.dart';

import '../Models/frozen/CircleData.dart';

class CircleDataProvider extends ChangeNotifier {
  var circleDataList = List<CircleData>.filled(
    Global.TABS_ALLOWED,
    CircleData.empty(),
    growable: false,
  );

  setCircleDataElement(CircleData newCircleData, int index) {
    CircleData.copy(circleDataList[index], newCircleData);
    debugPrint(circleDataList[index].toString());
    notifyListeners();
  }
}
