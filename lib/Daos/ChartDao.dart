import 'package:chore_app/Models/frozen/Chart.dart';
import 'package:chore_app/Models/frozen/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
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
    for (int i = 0; i < (currUserDataObj.chartIDs?.length as int); i++) {
      final docRef =
          currChartCollection.doc(currUserDataObj.chartIDs?.elementAt(i));
      var subscription =
          docRef.snapshots(includeMetadataChanges: true).listen((event) {
        Provider.of<DisplayChartProvider>(context, listen: false).putChart(
            i,
            currUserDataObj.associatedTabNums?.elementAt(i) as int,
            Chart.fromSnapshot(event));
      });
      listOfListening.add(subscription);
    }
  }

  static endListeningToCharts() {
    debugPrint("Ending");
    for (int i = 0; i < listOfListening.length; i++) {
      debugPrint("End:" + i.toString());
      listOfListening.elementAt(i).cancel();
    }
    // for (int i = 0; i < (currUserDataObj.chartIDs?.length as int); i++) {
    //   final docRef =
    //       currChartCollection.doc(currUserDataObj.chartIDs?.elementAt(i));
    //   docRef.snapshots()((event) {
    //     Provider.of<DisplayChartProvider>(context, listen: false).putChart(
    //         i,
    //         currUserDataObj.associatedTabNums?.elementAt(i) as int,
    //         Chart.fromSnapshot(event));
    //   });
    // }
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
