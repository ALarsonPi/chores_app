import 'dart:collection';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import '../Daos/ChartDao.dart';
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

  clearCharts() {
    usersCharts.clear();
    notifyListeners();
  }

  Future<String> addChartToFirebase(Chart newChart, int index) async {
    if (usersCharts[index] == newChart) return "";
    String idFromFirebase = await ChartDao.addChart(newChart);
    usersCharts[index] = newChart.copyWith(
      id: idFromFirebase,
      chartTitle: newChart.chartTitle,
      numberOfRings: newChart.numberOfRings,
      ownerID: newChart.ownerID,
      editorIDs: newChart.editorIDs,
      viewerIDs: newChart.viewerIDs,
      circleOneText: newChart.circleOneText,
      circleTwoText: newChart.circleTwoText,
      circleThreeText: newChart.circleThreeText,
    );
    notifyListeners();
    return idFromFirebase;
  }

  deleteChart(Chart currChart, int index) async {
    await ChartDao.deleteChart(currChart);
    usersCharts[index] = Chart.emptyChart;
    notifyListeners();
  }

  updateChartTitle(int index, String newTitle) async {
    usersCharts[index] =
        (usersCharts[index] as Chart).copyWith(chartTitle: newTitle);
    notifyListeners();
    if (usersCharts[index] != Chart.emptyChart &&
        (usersCharts[index] as Chart).id.isNotEmpty) {
      await ChartDao.updateChart((usersCharts[index] as Chart));
    }
  }
}
