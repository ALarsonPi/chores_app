import 'dart:async';

import 'package:chore_app/Daos/ParentDao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../Daos/ChartDao.dart';
import '../Daos/UserDao.dart';
import '../Global.dart';
import '../Models/frozen/Chart.dart';
import '../Models/frozen/UserModel.dart';

class ListenService {
  static late StreamSubscription userListener;
  static ValueNotifier<UserModel> userNotifier =
      ValueNotifier<UserModel>(UserModel.emptyUser);
  static List<ValueNotifier<Chart>> chartsNotifiers =
      List.filled(Global.NUM_CHARTS, ValueNotifier<Chart>(Chart.emptyChart));

  static void initializeListeners(UserModel currUser) {
    if (currUser != userNotifier.value) {
      debugPrint("Initializing user listener");
      setUpUserListener(currUser);
    }
    if (chartsNotifiers.isEmpty) {
      setUpChartListeners(currUser);
    }
  }

  static void setUpUserListener(UserModel currUser) {
    userNotifier.value = currUser;
    final DocumentReference docRef = UserDao().getUserDocByID(currUser.id);
    var subscription = docRef.snapshots().listen((event) {
      userNotifier.value = UserModel.fromSnapshot(event);
    });
    userListener = subscription;
  }

  static void setUpChartListeners(UserModel currUser) {
    if (userNotifier.value.chartIDs != null) {
      debugPrint("Initializing chart listeners");
      List<String> charts = (userNotifier.value.chartIDs as List<String>);
      for (int i = 0; i < charts.length; i++) {
        chartsNotifiers.add(
          ValueNotifier(
            addChartListenerByFullID(i, charts[i]),
          ),
        );
      }
    } else {
      debugPrint("User had no chart ids to listen to");
    }
  }

  static void onChanged(Chart chart, int index) {
    if (chart == chartsNotifiers.elementAt(index).value) {
      debugPrint("Already listening");
      return;
    }

    // int index = chartsNotifiers
    //     .toList()
    //     .elemente((element) => element.value.id == chart.id)
    //     .first
    //     .value;

    debugPrint(
      "There wwas a change for listener: " +
          chart.chartTitle +
          "(" +
          chart.id +
          ")",
    );

    // If a change removes this user from the chart, set it as empty,
    // end listening to it, and remove from user object
    UserModel currUser = userNotifier.value;
    if (!chart.pendingIDs.contains(currUser.id) &&
        !chart.viewerIDs.contains(currUser.id) &&
        !chart.editorIDs.contains(currUser.id) &&
        !chart.ownerIDs.contains(currUser.id)) {
      cancelListeningToChartAtIndex(index, chart.id);
      return;
    }

    // debugPrint("About to update value to " + updatedChart.toString());
    // if (chart !=
    //     Global.getIt.get<ChartList>().getCurrNotifierByIndex(index).value) {
    //   // debugPrint("Weren't equal");
    // } else {
    //   // debugPrint("Were equal before");
    // }
    // Global.getIt.get<ChartList>().getCurrNotifierByIndex(indexToAdd).value =
    //     updatedChart;
    // if (updatedChart ==
    //     Global.getIt
    //         .get<ChartList>()
    //         .getCurrNotifierByIndex(indexToAdd)
    //         .value) {
    //   // debugPrint("Now are equal");
    // }
    return;
  }

  static void cancelListeningToChartAtIndex(int index, String chartID) {
    debugPrint("Cancelling listener at index " + index.toString());
    Global.streamMap[index]?.cancel();

    // Update Notifier to point to emptyChart
    chartsNotifiers.elementAt(index).value = Chart.emptyChart;
    UserDao userDao = UserDao();
    userDao.updateList(
        'associatedTabNums', chartID, chartID, ListAction.REMOVE);
  }

  static void cancelListeningToUser() {
    debugPrint("Cancelling user listener");
    userListener.cancel();
  }

  static cancelListeningToCharts() {
    debugPrint("ENDING LISTEN TO ALL");
    for (int i = 0; i < Global.streamMap.length; i++) {
      Global.streamMap.values.elementAt(i).cancel();
      chartsNotifiers.elementAt(i).value = Chart.emptyChart;
    }
    Global.streamMap.clear();
  }

  static void removeTabFromUser(int tabNum, String chartID) {
    List<int> currTabs = List.empty(growable: true);
    if (userNotifier.value.associatedTabNums != null) {
      currTabs.addAll(userNotifier.value.associatedTabNums as List<int>);
    }
    currTabs.remove(tabNum);

    List<String> currIds = List.empty(growable: true);
    if (userNotifier.value.chartIDs != null) {
      currIds.addAll(userNotifier.value.chartIDs as List<String>);
    }
    currIds.remove(chartID);

    userNotifier.value = userNotifier.value
        .copyWith(associatedTabNums: currTabs, chartIDs: currIds);
  }

  static void addChartListenerByPartID(
      int indexToAdd, String partID, UserModel currUser) async {
    Chart currChart = await ChartDao.getChartFromSubstringID(partID);
    addChartListenerByFullID(indexToAdd, currChart.id);
  }

  static Chart addChartListenerByFullID(int indexToAdd, String fullID) {
    final DocumentReference docRef = ChartDao.getChartDocByID(fullID);
    Chart updatedChart = Chart.emptyChart;
    var subscription = docRef.snapshots().listen((event) {});
    // debugPrint("Adding new listener");
    Global.streamMap.putIfAbsent(indexToAdd, () => subscription);
    return updatedChart;
  }
}
