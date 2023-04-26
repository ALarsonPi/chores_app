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
  static late StreamSubscription? userListener;
  static ValueNotifier<UserModel> userNotifier =
      ValueNotifier<UserModel>(UserModel.emptyUser);
  static List<ValueNotifier<Chart>> chartsNotifiers =
      List.filled(Global.NUM_CHARTS, ValueNotifier<Chart>(Chart.emptyChart));

  static void initializeListeners(UserModel currUser) {
    if (currUser != userNotifier.value) {
      debugPrint("Initializing user listener");
      setUpUserListener(currUser);
    }
    setUpChartListeners(currUser);
  }

  static void setUpUserListener(UserModel currUser) {
    userNotifier.value = currUser;
    final DocumentReference docRef = UserDao().getUserDocByID(currUser.id);
    var subscription = docRef.snapshots().listen((event) {
      userNotifier.value = UserModel.fromSnapshot(event);
      // Fix that only works for one tab
      if (userNotifier.value.chartIDs != null &&
          userNotifier.value.chartIDs!.isEmpty) {
        debugPrint("User found charts empty");
        for (var stream in Global.streamMap.entries) {
          stream.value.cancel();
        }
        for (var notifiers in chartsNotifiers) {
          notifiers.value = Chart.emptyChart;
        }
      }
    });
    userListener = subscription;
  }

  static void updateChartListenersIfUserHasNoCharts() {
    if (userNotifier.value.chartIDs!.isNotEmpty) {
      debugPrint("Initializing chart listeners");
      debugPrint((userNotifier.value.chartIDs as List<String>).toString());
    } else {
      // If user has no charts to listen to
      // no charts should be shown
      // hacky way at fixing bigger problem, but
      // works for now
      for (var notifier in chartsNotifiers) {
        notifier.value = Chart.emptyChart;
      }
    }
  }

  static void setUpChartListeners(UserModel currUser) {
    if (userNotifier.value.chartIDs != null) {
      // updateChartListenersIfUserHasNoCharts();
      List<String> charts = (userNotifier.value.chartIDs as List<String>);
      for (int i = 0; i < charts.length; i++) {
        debugPrint("Initializing Chart listener(${i}");
        chartsNotifiers[i].value = addChartListenerByFullID(i, charts[i]);
      }
    } else {
      debugPrint("User had no chart ids to listen to");
    }
  }

  static void onChanged(Chart chart, int index) {
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
      // cancelListeningToChartAtIndex(
      //   index,
      //   chart.id,
      //   currUser.id,
      //   chart,
      //   currUser,
      // );
      return;
    }
    return;
  }

  static void cancelListeningToChartAtIndex(
    int index,
    String chartID,
    String userID,
    Chart chart,
    UserModel user,
  ) {
    debugPrint("Cancelling listener at index " + index.toString());
    Global.streamMap[index]?.cancel();

    // Update Notifier to point to emptyChart
    chartsNotifiers.elementAt(index).value = Chart.emptyChart;
    UserDao userDao = UserDao();
    userDao.updateList('chartIDs', chartID, userID, ListAction.REMOVE);
    userDao.updateList('associatedTabNums', index, userID, ListAction.REMOVE);
  }

  static void cancelListeningToUser() {
    userListener?.cancel();
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
    var subscription = docRef.snapshots().listen((event) {
      Chart chart = Chart.fromSnapshot(event);
      updatedChart = chart;
      if (chart == chartsNotifiers.elementAt(indexToAdd).value) {
        debugPrint("Already listening and no change");
        return;
      } else {
        if (chartsNotifiers[indexToAdd].value == Chart.emptyChart) {
          debugPrint("Initializing Chart Data");
        } else {
          onChanged(chart, indexToAdd);
        }
        chartsNotifiers[indexToAdd].value = chart;
      }
    });
    // debugPrint("Adding new listener");
    Global.streamMap.putIfAbsent(indexToAdd, () => subscription);
    return updatedChart;
  }
}
