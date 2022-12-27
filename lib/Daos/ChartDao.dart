import 'package:chore_app/Models/frozen/Chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChartDao {
  static final CollectionReference currChartCollection =
      FirebaseFirestore.instance.collection('charts');

  static Future<String> addChart(Chart currChart) async {
    DocumentReference docRef =
        await currChartCollection.add(currChart.toJson());
    return docRef.id;
  }

  static void updateChart(Chart currChart) async {
    await currChartCollection.doc(currChart.id).update(
          currChart.toJson(),
        );
  }

  static void deleteChart(Chart currChart) async {
    await currChartCollection.doc(currChart.id).delete();
  }

// Will need to update to actually query and get the actual charts
  static Future<Chart> getCurrChart(String email) async {
    Chart ChartFromDatabase = Chart(
        id: "id",
        chartTitle: "Default Title",
        numberOfRings: 3,
        circleOneText: ["", "", "", ""],
        circleTwoText: ["", "", "", ""],
        circleThreeText: ["", "", "", ""],
        ownerID: "ownerID",
        tabNumForOwner: 0,
        editorIDs: List.empty(),
        viewerIDs: List.empty());
    await currChartCollection
        .where("email", isEqualTo: email.toLowerCase())
        .limit(1)
        .get()
        .then((QuerySnapshot value) => {
              if (value.docs.isNotEmpty)
                ChartFromDatabase = Chart.fromSnapshot(value.docs.elementAt(0)),
            });
    return ChartFromDatabase;
  }
}
