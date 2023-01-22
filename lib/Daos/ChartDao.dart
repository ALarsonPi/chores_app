import 'dart:async';
import 'dart:collection';

import 'package:chore_app/Daos/UserDao.dart';
import 'package:chore_app/Models/frozen/Chart.dart';
import 'package:chore_app/Models/frozen/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../Global.dart';

class ChartDao {
  static final CollectionReference currChartCollection =
      FirebaseFirestore.instance.collection('charts');
  static final CollectionReference currUserCollection =
      FirebaseFirestore.instance.collection('users');

  static Future<Chart> getChartFromSubstringID(String subStringId) async {
    final chartDoc = await currChartCollection
        .where("id", isGreaterThanOrEqualTo: subStringId)
        .where("id", isLessThanOrEqualTo: '$subStringId\uf8ff')
        .limit(1)
        .get();
    Chart desiredChart;

    try {
      desiredChart = Chart.fromSnapshot(chartDoc.docs.first);
    } catch (e) {
      debugPrint("Error - chart not found");
      desiredChart = Chart.emptyChart;
    }
    return desiredChart;
  }

  static DocumentReference getChartDocByID(String id) {
    return currChartCollection.doc(id);
  }

  static addPendingRequest(String pendingUserID, String chartID) async {
    Chart desiredChart = await getChartFromSubstringID(chartID);

    List<String> allPendingUserIds = List.empty(growable: true);
    allPendingUserIds.addAll(desiredChart.pendingIDs);
    if (!allPendingUserIds.contains(pendingUserID)) {
      allPendingUserIds.add(pendingUserID);
    }

    currChartCollection
        .doc(desiredChart.id)
        .update(desiredChart.copyWith(pendingIDs: allPendingUserIds).toJson());
  }

  static Future<List<Chart>> getChartsForUser(User user) async {
    List<Chart> chartList = List.empty(growable: true);

    if (user.chartIDs != null) {
      for (String chartId in user.chartIDs as List<String>) {
        Chart retrievedChart = await getChartByID(chartId);
        chartList.add(retrievedChart);
      }
    }
    return chartList;
  }

  static removeListener(int indexToRemove) {
    // debugPrint("Removing listener for index:" + indexToRemove.toString());
    Global.streamMap[indexToRemove]?.cancel();
  }

  static endListeningToCharts() {
    // debugPrint("ENDING LISTEN TO ALL");
    for (int i = 0; i < Global.streamMap.length; i++) {
      Global.streamMap.values.elementAt(i).cancel();
    }
    Global.streamMap.clear();
  }

  static Future<String> addChart(Chart currChart) async {
    DocumentReference docRef =
        await currChartCollection.add(currChart.toJson());
    updateChart(currChart.copyWith(id: docRef.id));
    return docRef.id;
  }

  static Future<void> updateChart(Chart currChart) async {
    await currChartCollection.doc(currChart.id).update(
          currChart.toJson(),
        );
  }

  static Future<void> deleteChart(Chart currChart) async {
    await currChartCollection.doc(currChart.id).delete();
  }

// Will need to update to actually query and get the actual charts
  static Future<Chart> getChartByID(String id) async {
    Chart ChartFromDatabase = Chart.emptyChart;
    await currChartCollection
        .where("id", isEqualTo: id)
        .limit(1)
        .get()
        .then((QuerySnapshot value) => {
              if (value.docs.isNotEmpty && value.docs.elementAt(0) != null)
                {
                  ChartFromDatabase =
                      Chart.fromSnapshot(value.docs.elementAt(0)),
                }
            });
    return ChartFromDatabase;
  }

  static Future<String> addChartToFirebase(Chart newChart, int index) async {
    String idFromFirebase = await ChartDao.addChart(newChart);
    return idFromFirebase;
  }
}
