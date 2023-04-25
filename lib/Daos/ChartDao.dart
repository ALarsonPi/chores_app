import 'dart:async';

import 'package:chore_app/Models/frozen/Chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../Global.dart';
import '../Models/frozen/UserModel.dart';
import 'ParentDao.dart';

class ChartDao extends ParentDao {
  static final CollectionReference currChartCollection =
      FirebaseFirestore.instance.collection('charts');

  @override
  CollectionReference<Object?> getCollection() {
    return currChartCollection;
  }

  static getChartStreamFromFirestore() {
    return currChartCollection.snapshots();
  }

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

  addPendingRequest(String pendingUserID, String chartID) async {
    await updateList('pendingIDs', pendingUserID, chartID, ListAction.ADD);
  }

  static Future<List<Chart>> getChartsForUser(UserModel user) async {
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

  Future<String> addChart(Chart currChart) async {
    DocumentReference docRef =
        await currChartCollection.add(currChart.toJson());
    await updateChartID(docRef.id, docRef.id);
    return docRef.id;
  }

  updateChartID(String newID, String chartID) async {
    await updateValue('id', newID, chartID);
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

  Future<void> updateTitle(String newTitle, String chartID) async {
    await updateValue('chartTitle', newTitle, chartID);
  }

  Future<void> addPendingID(String chartID, String pendingID) async {
    await updateList('pendingIDs', pendingID, chartID, ListAction.ADD);
  }

  Future<void> removeUserIDFromChart(String userID, chartID) async {
    await updateList('pendingIDs', userID, chartID, ListAction.REMOVE);
    await updateList('viewerIDs', userID, chartID, ListAction.REMOVE);
    await updateList('editorIDs', userID, chartID, ListAction.REMOVE);
    await updateList('ownerIDs', userID, chartID, ListAction.REMOVE);
  }

  Future<void> removePendingID(String chartID, String pendingID) async {
    await updateList('pendingIDs', pendingID, chartID, ListAction.REMOVE);
  }

  Future<void> addViewerID(String chartID, String viewerID) async {
    await updateList('viewerIDs', viewerID, chartID, ListAction.ADD);
  }

  Future<void> removeViewerID(String chartID, String viewerID) async {
    await updateList('viewerIDs', viewerID, chartID, ListAction.REMOVE);
  }

  Future<void> addEditorID(String chartID, String editorID) async {
    await updateList('editorIDs', editorID, chartID, ListAction.ADD);
  }

  Future<void> removeEditorID(String chartID, String editorID) async {
    await updateList('editorIDs', editorID, chartID, ListAction.REMOVE);
  }

  Future<void> addOwnerID(String chartID, String ownerID) async {
    await updateList('ownerIDs', ownerID, chartID, ListAction.ADD);
  }

  Future<void> removeOwnerID(String chartID, String ownerID) async {
    await updateList('ownerIDs', ownerID, chartID, ListAction.REMOVE);
  }

  Future<void> updateChartAngle(
      int chartRingNum, double angleValue, String chartID) async {
    String parameterToUpdate = 'circleOneAngle';
    if (chartRingNum == 2) {
      parameterToUpdate = 'circleTwoAngle';
    } else if (chartRingNum == 3) {
      parameterToUpdate = 'circleThreeAngle';
    }
    await updateValue(parameterToUpdate, angleValue, chartID);
  }
}
