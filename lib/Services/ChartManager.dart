import 'package:chore_app/Global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Daos/ChartDao.dart';
import '../Daos/UserDao.dart';
import '../Models/frozen/Chart.dart';
import '../Models/frozen/UserModel.dart';
import 'UserManager.dart';

class ChartList {
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

  addListenersForChartsFromFirebase(UserModel currUser) {
    if (currUser.chartIDs == null) {
      debugPrint("No chartIDs");
      return;
    }
    List<String> currIds = currUser.chartIDs as List<String>;
    for (int i = 0; i < currIds.length; i++) {
      addListenerByFullID(currUser.associatedTabNums?.elementAt(i) as int,
          currIds.elementAt(i));
    }
  }

  addListenerByPartID(int indexToAdd, String partID, UserModel currUser) async {
    Chart currChart = await ChartDao.getChartFromSubstringID(partID);
    addListenerByFullID(indexToAdd, currChart.id);
  }

  addListenerByFullID(int indexToAdd, String fullID) {
    final DocumentReference docRef = ChartDao.getChartDocByID(fullID);
    Chart updatedChart = Chart.emptyChart;
    var subscription = docRef.snapshots().listen((event) {
      updatedChart = Chart.fromSnapshot(event);

      // debugPrint("In listener: " + currUser.toString());
      if (updatedChart ==
          Global.getIt
              .get<ChartList>()
              .getCurrNotifierByIndex(indexToAdd)
              .value) return;

      UserModel currUser = Global.getIt.get<UserManager>().currUser.value;

      // debugPrint("Updated Chart: " + updatedChart.toString());

      // If a change removes this user from the chart, set it as empty,
      // end listening to it, and remove from user object
      if (!updatedChart.pendingIDs.contains(currUser.id) &&
          !updatedChart.viewerIDs.contains(currUser.id) &&
          !updatedChart.editorIDs.contains(currUser.id) &&
          !updatedChart.ownerIDs.contains(currUser.id)) {
        Global.streamMap[indexToAdd]?.cancel();
        debugPrint(currUser.toString());
        debugPrint("CANCELLING to changes for : " + updatedChart.chartTitle);
        debugPrint("CANCELLING to changes for : " + updatedChart.toString());

        Global.getIt.get<ChartList>().getCurrNotifierByIndex(indexToAdd).value =
            Chart.emptyChart;
        Global.getIt.get<UserManager>().removeTabFromUser(
              indexToAdd,
              updatedChart.id,
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

  int? isChartAlreadyUsed(UserModel currUser, String? id) {
    if (currUser.chartIDs == null) return -1;
    for (int i = 0; i < (currUser.chartIDs as List<String>).length; i++) {
      if (currUser.chartIDs?.elementAt(i).contains(id as String) as bool) {
        return i;
      }
    }
    return -1;
  }

  processChartJoinRequest(Chart chartToJoin, UserModel currUser) async {
    if (chartToJoin == Chart.emptyChart) {
      Global.makeSnackbar("ERROR: Unable to join chart");
      return;
    }

    int num = isChartAlreadyUsed(currUser, chartToJoin.id) as int;
    if (num != -1) {
      Global.makeSnackbar(
        "You are already a part of that chart\nIt is your Chart ${num + 1}",
      );
    } else {
      Chart currChart = await ChartDao.getChartFromSubstringID(chartToJoin.id);
      if (currChart == Chart.emptyChart) {
        Global.makeSnackbar("No Chart found with that code. Please make " +
            "sure you have the correct code and try again");
        return;
      }

      await ChartDao.addPendingRequest(currUser.id, chartToJoin.id);
      currChart = currChart.addPendingID(currChart, currUser.id);

      Global.getIt.get<UserManager>().addTabToUser(0, currChart.id);

      UserDao.updateUserInFirebase(
          Global.getIt.get<UserManager>().currUser.value);

      Global.getIt.get<ChartList>().addListenerByFullID(0, currChart.id);
    }
  }
}
