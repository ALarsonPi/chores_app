import 'dart:async';
import 'dart:collection';

import 'package:chore_app/Models/frozen/Chart.dart';
import 'package:chore_app/Models/frozen/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../Global.dart';
import '../Providers/DisplayChartProvider.dart';

class ChartDao {
  static final CollectionReference currChartCollection =
      FirebaseFirestore.instance.collection('charts');
  static final CollectionReference currUserCollection =
      FirebaseFirestore.instance.collection('users');

  static List listOfListening = List.empty(growable: true);

  static getAndListenToChartsForUser(
      User currUserDataObj, BuildContext context) {
    if (currUserDataObj.chartIDs == null) return;
    debugPrint("Adding all listener");

    for (int i = 0; i < (currUserDataObj.chartIDs?.length as int); i++) {
      int tabIndex = currUserDataObj.associatedTabNums?.elementAt(i) as int;
      addListenerAtIndex(tabIndex,
          currUserDataObj.chartIDs?.elementAt(i) as String, context, false);
    }
  }

  static removeListener(int indexToRemove) {
    debugPrint("Removing listener for index:" + indexToRemove.toString());
    Global.streamMap[indexToRemove]?.cancel();
  }

  static addListenerAtIndex(
      int index, String uid, BuildContext context, bool shouldRefresh) {
    final docRef = currChartCollection.doc(uid);
    var subscription =
        docRef.snapshots(includeMetadataChanges: true).listen((event) {
      Future.delayed(
        Duration.zero,
        Provider.of<DisplayChartProvider>(context, listen: false).updateChart(
          index,
          Chart.fromSnapshot(event),
        ),
      );
    });
    Global.streamMap.putIfAbsent(index, () => subscription);
  }

  static addListener(User currUser, int indexToAdd, BuildContext context) {
    final docRef =
        currChartCollection.doc(currUser.chartIDs?.elementAt(indexToAdd));
    var subscription =
        docRef.snapshots(includeMetadataChanges: true).listen((event) {
      debugPrint(
          "THERE was a change for " + Chart.fromSnapshot(event).chartTitle);
      Future.delayed(
          Duration.zero,
          Provider.of<DisplayChartProvider>(context, listen: false).putChart(
              indexToAdd,
              currUser.associatedTabNums?.elementAt(indexToAdd) as int,
              Chart.fromSnapshot(event)));
    });
    Global.streamMap.putIfAbsent(indexToAdd, () => subscription);
  }

  static endListeningToCharts() {
    debugPrint("ENDING LISTEN TO ALL");
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
              if (value.docs.isNotEmpty)
                ChartFromDatabase = Chart.fromSnapshot(value.docs.elementAt(0)),
            });
    return ChartFromDatabase;
  }
}
