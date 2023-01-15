import 'dart:collection';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import '../Models/frozen/Chart.dart';

class DisplayChartProvider extends ChangeNotifier {
  Map<int, Chart> usersCharts = HashMap();

  putChart(int index, int tabNum, Chart chart) {
    if (usersCharts.isEmpty || !usersCharts.keys.contains(index)) {
      usersCharts.putIfAbsent(tabNum, () => chart);
    } else {
      usersCharts.update(tabNum, (value) => chart, ifAbsent: () => chart);
    }
    notifyListeners();
  }

  updateChart(int tabNum, Chart chart) {
    if (usersCharts.isEmpty || !usersCharts.keys.contains(tabNum)) {
      usersCharts.putIfAbsent(tabNum, () => chart);
    } else {
      usersCharts.update(tabNum, (value) => chart, ifAbsent: () => chart);
    }
    notifyListeners();
  }
}
