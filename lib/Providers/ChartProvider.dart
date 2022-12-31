import 'package:chore_app/Daos/ChartDao.dart';
import 'package:chore_app/Global.dart';
import 'package:flutter/cupertino.dart';

import '../Models/frozen/Chart.dart';

class ChartProvider extends ChangeNotifier {
  List<String> circle1Text = [
    "John",
    "Jamie",
    "Will",
    "Abby",
    // "Jake",
    // "Johnny",
    // "Santa",
    // "Abe"
  ];

  List<String> circle2Text = [
    "Clean/Clear Table",
    "Pots/Pans",
    "Dishwasher",
    "Bathrooms",
    // "Vaccuum (All carpet)",
    // "Lawn and mow and lawn",
    // "Clean Window and clean"
  ];

  List<String> circle3Text = [
    "Wash Windows and Blinds",
    "Dust Baseboards and Blinds",
    "Mow lawn",
    "Babysit baby Kylie",
    // "Mop floors",
    // "Give coal to yessir",
    // "Beat the South yessir",
    // "Run run run away yessir",
  ];

  late Chart exampleCircle = Chart(
    id: "example1",
    chartTitle: "Example Chart",
    numberOfRings: 3,
    ownerID: "",
    tabNumForOwner: 0,
    editorIDs: List.empty(),
    viewerIDs: List.empty(),
    circleOneText: circle1Text,
    circleTwoText: circle2Text,
    circleThreeText: circle3Text,
  );

  late Chart exampleCircle2 = Chart(
    id: "example2",
    chartTitle: "Second Chart",
    numberOfRings: 2,
    ownerID: "",
    tabNumForOwner: 0,
    editorIDs: List.empty(),
    viewerIDs: List.empty(),
    circleOneText: circle1Text,
    circleTwoText: circle2Text,
    circleThreeText: [],
  );

  // late var circleDataList = List<Chart>.filled(
  //   Global.TABS_ALLOWED,
  //   exampleCircle,
  //   growable: false,
  // );

  late var circleDataList = [
    exampleCircle,
    exampleCircle2,
    Chart.emptyChart,
  ];

  addChartToFirebase(Chart newChart, int index) async {
    if (circleDataList[index] == newChart) return;
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
