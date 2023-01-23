import 'package:chore_app/Global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Daos/ChartDao.dart';
import '../Daos/UserDao.dart';
import '../Models/frozen/Chart.dart';
import '../Models/frozen/User.dart';

class ChartList {
  // ValueNotifier<List<Chart>> userCharts = ValueNotifier<List<Chart>>(
  //     List.filled(Global.TABS_ALLOWED, Chart.emptyChart));
  // List<ValueNotifier<Chart>> userCharts = List<ValueNotifier<Chart>>.filled(
  //   Global.TABS_ALLOWED,
  //   ValueNotifier<Chart>(
  //     Chart.emptyChart,
  //   ),
  // );

  ValueNotifier<Chart> firstChart = ValueNotifier<Chart>(
    Chart.emptyChart,
  );

  ValueNotifier<Chart> secondChart = ValueNotifier<Chart>(
    Chart.emptyChart,
  );

  ValueNotifier<Chart> thirdChart = ValueNotifier<Chart>(
    Chart.emptyChart,
  );

  getCurrNotifierByIndex(int index) {
    if (index == 0) {
      return firstChart;
    } else if (index == 1) {
      return secondChart;
    } else if (index == 2) {
      return thirdChart;
    } else {
      return ValueNotifier<Chart>(Chart.emptyChart);
    }
  }

  removeListener(int indexToRemove) {
    Global.streamMap[indexToRemove]?.cancel();
  }

  addListenersForChartsFromFirebase(User currUser) {
    if (currUser.chartIDs == null) {
      debugPrint("No chartIDs");
      return;
    }
    List<String> currIds = currUser.chartIDs as List<String>;
    for (int i = 0; i < currIds.length; i++) {
      addListenerByFullID(currUser.associatedTabNums?.elementAt(i) as int,
          currIds.elementAt(i), currUser);
    }
  }

  addListenerByPartID(int indexToAdd, String partID, User currUser) async {
    Chart currChart = await ChartDao.getChartFromSubstringID(partID);
    addListenerByFullID(indexToAdd, currChart.id, currUser);
  }

  addListenerByFullID(int indexToAdd, String fullID, User currUser) {
    final DocumentReference docRef = ChartDao.getChartDocByID(fullID);
    Chart updatedChart = Chart.emptyChart;
    var subscription = docRef.snapshots().listen((event) {
      updatedChart = Chart.fromSnapshot(event);

      debugPrint("In listener: " + currUser.toString());

      if (updatedChart ==
          Global.getIt
              .get<ChartList>()
              .getCurrNotifierByIndex(indexToAdd)
              .value) return;

      debugPrint("Updated Chart: " + updatedChart.toString());

      // If a change removes this user from the chart, set it as empty,
      // end listening to it, and remove from user object
      if (!updatedChart.pendingIDs.contains(currUser.id) &&
          !updatedChart.viewerIDs.contains(currUser.id) &&
          !updatedChart.editorIDs.contains(currUser.id) &&
          updatedChart.ownerID != currUser.id) {
        Global.streamMap[indexToAdd]?.cancel();
        debugPrint("CANCELLING to changes for : " + updatedChart.chartTitle);

        Global.getIt.get<ChartList>().getCurrNotifierByIndex(indexToAdd).value =
            Chart.emptyChart;
        currUser = currUser.removeTabFromUser(
          indexToAdd,
          updatedChart.id,
          currUser,
        );
        UserDao.updateUserInFirebase(currUser);
        return;
      }

      // debugPrint("About to update value to " + updatedChart.toString());
      if (updatedChart !=
          Global.getIt
              .get<ChartList>()
              .getCurrNotifierByIndex(indexToAdd)
              .value) {
        // debugPrint("Weren't equal");
      } else {
        // debugPrint("Were equal before");
      }
      Global.getIt.get<ChartList>().getCurrNotifierByIndex(indexToAdd).value =
          updatedChart;
      if (updatedChart ==
          Global.getIt
              .get<ChartList>()
              .getCurrNotifierByIndex(indexToAdd)
              .value) {
        // debugPrint("Now are equal");
      }
      return;
    });
    // debugPrint("Adding new listener");
    Global.streamMap.putIfAbsent(indexToAdd, () => subscription);
    return updatedChart;
  }

  updateChartTitle(int index, String newTitle) async {
    getCurrNotifierByIndex(index).value =
        getCurrNotifierByIndex(index).value.copyWith(chartTitle: newTitle);
  }

  setChartsToEmpty() {
    for (int i = 0; i < Global.TABS_ALLOWED; i++) {
      getCurrNotifierByIndex(i).value = Chart.emptyChart;
    }
  }
}
