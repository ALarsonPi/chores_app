import 'package:chore_app/Daos/ChartDao.dart';
import 'package:flutter/cupertino.dart';

import '../Models/ChartDataHolder.dart';
import '../Models/frozen/Chart.dart';

class ChartProvider extends ChangeNotifier {
  late List<Chart> circleDataList = [
    Chart.emptyChart,
    Chart.emptyChart,
    Chart.emptyChart,
  ];

  getChartFromDatabase(String chartID, int index) async {
    Chart chart = await ChartDao.getChartByID(chartID);
    circleDataList[index] = chart;
  }

  setChartData(Chart chart, int index) {
    circleDataList[index] = chart;
    notifyListeners();
  }

  Future<String> addChartToFirebase(Chart newChart, int index) async {
    if (circleDataList[index] == newChart) return "";
    String idFromFirebase = await ChartDao.addChart(newChart);
    circleDataList[index] = newChart.copyWith(
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

    circleDataList[index] = Chart.emptyChart;
    notifyListeners();
  }

  updateChartTitle(int index, String newTitle) async {
    circleDataList[index] =
        circleDataList[index].copyWith(chartTitle: newTitle);
    notifyListeners();
    await ChartDao.updateChart(circleDataList[index]);
  }
}
