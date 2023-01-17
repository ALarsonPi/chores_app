import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'Chart.freezed.dart';
part 'Chart.g.dart';

@freezed
class Chart with _$Chart {
  Chart._();

  factory Chart({
    required String id,
    required String chartTitle,
    required int numberOfRings,
    required List<String> circleOneText,
    required List<String> circleTwoText,
    required String ownerID,
    required int tabNumForOwner,
    required List<String> editorIDs,
    required List<String> viewerIDs,
    required List<String> pendingIDs,
    List<String>? circleThreeText,
  }) = _Chart;

  static Chart emptyChart = Chart(
    id: "",
    chartTitle: "",
    ownerID: "",
    tabNumForOwner: 0,
    editorIDs: [],
    viewerIDs: [],
    pendingIDs: [],
    numberOfRings: 0,
    circleOneText: [],
    circleTwoText: [],
    circleThreeText: [],
  );

  factory Chart.fromJson(Map<String, dynamic> json) => _$ChartFromJson(json);

  factory Chart.fromSnapshot(DocumentSnapshot snapshot) {
    Chart newChart = (snapshot.data() == null)
        ? Chart.emptyChart
        : Chart.fromJson(snapshot.data() as Map<String, dynamic>);
    return newChart;
  }

  // static void copy(Chart objToCopyTo, Chart objToCopyFrom) {
  //   objToCopyTo.circleID = objToCopyFrom.circleID;
  //   objToCopyTo.chartTitle = objToCopyFrom.chartTitle;
  //   objToCopyTo.circleOneText = objToCopyFrom.circleOneText;
  //   objToCopyTo.circleTwoText = objToCopyFrom.circleTwoText;
  //   objToCopyTo.circleThreeText = objToCopyFrom.circleThreeText;
  // }
}
