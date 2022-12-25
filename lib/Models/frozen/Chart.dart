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
    List<String>? circleThreeText,
    int? chartColorIndex,
  }) = _Chart;

  static Chart emptyChart = Chart(
    id: "",
    chartTitle: "",
    numberOfRings: 0,
    circleOneText: [],
    circleTwoText: [],
    circleThreeText: [],
  );

  factory Chart.fromJson(Map<String, dynamic> json) => _$ChartFromJson(json);

  factory Chart.fromSnapshot(DocumentSnapshot snapshot) {
    Chart newChart = Chart.fromJson(snapshot.data() as Map<String, dynamic>);
    // newChart = newChart.copyWith(id: snapshot.reference.id);
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
