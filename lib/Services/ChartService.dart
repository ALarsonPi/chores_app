import 'package:chore_app/Global.dart';
import 'package:chore_app/Services/ListenService.dart';
import 'package:flutter/cupertino.dart';

import '../Daos/ChartDao.dart';
import '../Daos/ParentDao.dart';
import '../Daos/UserDao.dart';
import '../Models/frozen/Chart.dart';
import '../Models/frozen/UserModel.dart';

class ChartService {
  ChartDao chartDao = ChartDao();

  int? isChartAlreadyUsed(UserModel currUser, String? id) {
    if (currUser.chartIDs == null) return -1;
    for (int i = 0; i < (currUser.chartIDs as List<String>).length; i++) {
      if (currUser.chartIDs?.elementAt(i).contains(id as String) as bool) {
        return i;
      }
    }
    return -1;
  }

  // Remove User from other lists
  // add User to correct list
  void setUserRoleForChart(
      String newRole, String userID, Chart chart, bool isJoiningChart) {
    String propertyToChange = "";
    if (newRole == "Viewer") {
      propertyToChange = "viewerIDs";
      if (chart.editorIDs.contains(userID)) {
        chartDao.updateList("editorIDs", userID, chart.id, ListAction.REMOVE);
      } else if (chart.ownerIDs.contains(userID)) {
        chartDao.updateList("ownerIDs", userID, chart.id, ListAction.REMOVE);
      }
    } else if (newRole == "Editor") {
      propertyToChange = "editorIDs";
      if (chart.viewerIDs.contains(userID)) {
        chartDao.updateList("viewerIDs", userID, chart.id, ListAction.REMOVE);
      } else if (chart.ownerIDs.contains(userID)) {
        chartDao.updateList("ownerIDs", userID, chart.id, ListAction.REMOVE);
      }
    } else if (newRole == "Owner") {
      propertyToChange = "ownerIDs";
      if (chart.viewerIDs.contains(userID)) {
        chartDao.updateList("viewerIDs", userID, chart.id, ListAction.REMOVE);
      } else if (chart.editorIDs.contains(userID)) {
        chartDao.updateList("editorIDs", userID, chart.id, ListAction.REMOVE);
      }
    } else {
      debugPrint("ERROR");
    }

    if (isJoiningChart) {
      if (chart.pendingIDs.contains(userID)) {
        chartDao.updateList("pendingIDs", userID, chart.id, ListAction.REMOVE);
      }
    }
    chartDao.updateList(propertyToChange, userID, chart.id, ListAction.ADD);
  }

  void removeUserFromRoleForChart(
      String newRole, String userID, String chartID) {
    String propertyToChange = "";
    if (newRole == "Viewer") {
      propertyToChange = "viewerIDs";
    } else if (newRole == "Editor") {
      propertyToChange = "editorIDs";
    } else if (newRole == "Owner") {
      propertyToChange = "ownerIDs";
    } else {
      debugPrint("ERROR");
    }
    chartDao.updateList(propertyToChange, userID, chartID, ListAction.REMOVE);
  }

  static List<TabSaveStatus> tabSaveStatuses =
      List.filled(Global.NUM_CHARTS, TabSaveStatus());

  static void prepareSavedChartData(
      int tabNum, int ringNum, bool hasChanged, double newPosition) {
    if (ringNum == 1) {
      tabSaveStatuses.elementAt(tabNum).circleOneHasChanged = hasChanged;
      tabSaveStatuses.elementAt(tabNum).newPositionOne = newPosition;
    } else if (ringNum == 2) {
      tabSaveStatuses.elementAt(tabNum).circleTwoHasChanged = hasChanged;
      tabSaveStatuses.elementAt(tabNum).newPositionTwo = newPosition;
    } else if (ringNum == 3) {
      tabSaveStatuses.elementAt(tabNum).circleThreeHasChanged = hasChanged;
      tabSaveStatuses.elementAt(tabNum).newPositionThree = newPosition;
    } else {
      debugPrint("Error in indexes of prepare saved chart data");
    }
  }

  static bool tabHasDataToSave(int tabNum) {
    TabSaveStatus saveStatus = tabSaveStatuses.elementAt(tabNum);
    return saveStatus.circleOneHasChanged ||
        saveStatus.circleTwoHasChanged ||
        saveStatus.circleThreeHasChanged;
  }

  static void saveTabData(int tabNum, String chartID) {
    TabSaveStatus saveStatus = tabSaveStatuses.elementAt(tabNum);
    if (saveStatus.circleOneHasChanged) {
      ChartDao().updateChartAngle(1, saveStatus.newPositionOne, chartID);
    } else if (saveStatus.circleTwoHasChanged) {
      ChartDao().updateChartAngle(2, saveStatus.newPositionTwo, chartID);
    } else if (saveStatus.circleThreeHasChanged) {
      ChartDao().updateChartAngle(3, saveStatus.newPositionThree, chartID);
    } else {
      debugPrint("Error in Sae Tab Data function");
    }
    tabSaveStatuses[tabNum] = TabSaveStatus();
  }

  void processChartJoinRequest(Chart chartToJoin, UserModel currUser) async {
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
      await ChartDao().addPendingRequest(currUser.id, chartToJoin.id);
      await UserDao().addChartIDForUser(currChart.id, currUser.id);
      ListenService.addChartListenerByFullID(0, currChart.id);
    }
  }
}

class TabSaveStatus {
  bool circleOneHasChanged = false;
  double newPositionOne = 0.0;
  bool circleTwoHasChanged = false;
  double newPositionTwo = 0.0;
  bool circleThreeHasChanged = false;
  double newPositionThree = 0.0;

  @override
  String toString() {
    return "TabSaveStatus\n=============\n${circleOneHasChanged} | ${circleTwoHasChanged} | ${circleThreeHasChanged}\n(${newPositionOne}) | (${newPositionTwo}) | (${newPositionThree})";
  }
}
