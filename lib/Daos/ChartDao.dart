import 'package:async/async.dart';
import 'package:chore_app/Models/frozen/Chart.dart';
import 'package:chore_app/Models/frozen/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../Models/ChartDataHolder.dart';

class ChartDao {
  static final CollectionReference currChartCollection =
      FirebaseFirestore.instance.collection('charts');
  static final CollectionReference currUserCollection =
      FirebaseFirestore.instance.collection('users');

  static Stream<List<List<Chart>>> getChartsViaStream(String firebaseAuthID) {
    Query isOwner =
        currChartCollection.where("ownerID", isEqualTo: firebaseAuthID);
    Query isEditor =
        currChartCollection.where("editorIDs", arrayContains: firebaseAuthID);
    Query isViewer =
        currChartCollection.where("viewIDs", arrayContains: firebaseAuthID);

    Stream<List<Chart>> ownerStream = isOwner.snapshots().map((snapShot) =>
        snapShot.docs.map((document) => Chart.fromSnapshot(document)).toList());
    Stream<List<Chart>> editorStream = isEditor.snapshots().map((snapShot) =>
        snapShot.docs.map((document) => Chart.fromSnapshot(document)).toList());
    Stream<List<Chart>> viewerStream = isViewer.snapshots().map((snapShot) =>
        snapShot.docs.map((document) => Chart.fromSnapshot(document)).toList());

    return StreamZip([
      ownerStream,
      editorStream,
      viewerStream,
    ]);

    // Stream<List<Chart>> j;
    // for(List<Chart> k in ownerStream.first.first) {

    // }
// Observable.merge(([stream1, stream2])) is all the data from list2, but if I return Observable.merge(([stream2, stream1]))
//     StreamGroup.merge;
//     snapshots().map((snapShot) =>
//         snapShot.docs.map((document) => Chart.fromSnapshot(document)).toList());
  }

  static Future<List<ChartDataHolder>> getCharts(String currUserID) async {
    User currUser = User(id: "id");
    await currUserCollection
        .where("id", isEqualTo: currUserID)
        .limit(1)
        .get()
        .then((QuerySnapshot value) => {
              if (value.docs.isNotEmpty)
                currUser = User.fromSnapshot(value.docs.elementAt(0)),
            });

    List<String> connectedChartIds = List.empty(growable: true);
    List<int> tabNums = List.empty(growable: true);
    if (currUser.chartIDs != null) {
      connectedChartIds.addAll(currUser.chartIDs as Iterable<String>);
    }
    if (currUser.associatedTabNums != null) {
      tabNums.addAll(currUser.associatedTabNums as Iterable<int>);
    }

    List<ChartDataHolder> fullDataList = List.empty(growable: true);
    for (int i = 0; i < connectedChartIds.length; i++) {
      Chart chartToAdd = Chart.emptyChart;
      await currChartCollection
          .where("id", isEqualTo: connectedChartIds.elementAt(i))
          .limit(1)
          .get()
          .then((QuerySnapshot value) => {
                if (value.docs.isNotEmpty)
                  {
                    chartToAdd = Chart.fromSnapshot(value.docs.elementAt(0)),
                  }
              });
      fullDataList.add(ChartDataHolder(chartToAdd, tabNums.elementAt(i)));
    }

    return fullDataList;
  }

  static Future<String> addChart(Chart currChart) async {
    DocumentReference docRef =
        await currChartCollection.add(currChart.toJson());
    updateChart(currChart.copyWith(id: docRef.id));
    return docRef.id;
  }

  static Future<void> updateChart(Chart currChart) async {
    debugPrint(currChart.toString());
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
