import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
    required List<String> ownerIDs,
    required List<String> editorIDs,
    required List<String> viewerIDs,
    required List<String> pendingIDs,
    required double circleOneAngle,
    required double circleTwoAngle,
    required double circleThreeAngle,
    List<String>? circleThreeText,
  }) = _Chart;

  static Chart emptyChart = Chart(
    id: "",
    chartTitle: "",
    ownerIDs: List.empty(growable: true),
    editorIDs: List.empty(growable: true),
    viewerIDs: List.empty(growable: true),
    pendingIDs: List.empty(growable: true),
    numberOfRings: 0,
    circleOneText: List.empty(growable: true),
    circleTwoText: List.empty(growable: true),
    circleThreeText: List.empty(growable: true),
    circleOneAngle: 0,
    circleTwoAngle: 0,
    circleThreeAngle: 0,
  );

  factory Chart.fromJson(Map<String, dynamic> json) => _$ChartFromJson(json);

  factory Chart.fromSnapshot(DocumentSnapshot snapshot) {
    Chart newChart = (snapshot.data() == null)
        ? Chart.emptyChart
        : Chart.fromJson(snapshot.data() as Map<String, dynamic>);
    return newChart;
  }

  Chart addPendingID(Chart chart, String id) {
    List<String> currIds = List.empty(growable: true);
    currIds.addAll(pendingIDs);
    currIds.add(id);
    return chart.copyWith(pendingIDs: currIds);
  }

  Chart removeUserFromChart(Chart chart, String userToRemoveID) {
    List<String> currPendingIDs = List.empty(growable: true);
    List<String> currviewIDs = List.empty(growable: true);
    List<String> currEditingIDs = List.empty(growable: true);

    currPendingIDs.addAll(chart.pendingIDs);
    currviewIDs.addAll(chart.viewerIDs);
    currEditingIDs.addAll(chart.editorIDs);

    currPendingIDs.remove(userToRemoveID);
    currviewIDs.remove(userToRemoveID);
    currEditingIDs.remove(userToRemoveID);

    return chart.copyWith(
      pendingIDs: currPendingIDs,
      viewerIDs: currviewIDs,
      editorIDs: currEditingIDs,
    );
  }
}
