import 'package:chore_app/Global.dart';
import 'package:chore_app/Services/ListenService.dart';
import 'package:chore_app/Widgets/ChartDisplay/GiveOwnershipPopup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  List<String> getListForRole(String role, int index) {
    Chart chart = ListenService.chartsNotifiers.elementAt(index).value;
    if (role == "Owner") {
      return chart.ownerIDs;
    } else if (role == "Editor") {
      return chart.editorIDs;
    } else if (role == "Viewer") {
      return chart.viewerIDs;
    } else if (role == "Pending") {
      return chart.pendingIDs;
    } else {
      debugPrint("Error in getListforRole function");
      return [];
    }
  }

  void addUserToChartWithNewRole(int index, String userId, String newRole) {
    List<String> idList = getListForRole(newRole, index);
    if (!idList.contains(userId)) {
      ChartService().setUserRoleForChart(
        newRole,
        userId,
        ListenService.chartsNotifiers.elementAt(index).value,
        true,
        index,
        ListenService.chartsNotifiers.elementAt(index).value.id,
      );
    }
  }

  Future<void> showDeleteChartConfirmDialog(
      BuildContext context, Chart chartData, String userID,
      {String message = 'Are you sure you want to delete this chart?'}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Chart'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete',
                  style: TextStyle(
                    color: Colors.red,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
                ChartDao.removeListener(ListenService
                    .userNotifier.value.chartIDs
                    ?.indexOf(chartData.id) as int);
                UserDao().removeChartIDForUser(chartData.id, userID);
                ChartDao.deleteChart(chartData);
                ListenService.chartsNotifiers[0].value = Chart.emptyChart;
              },
            ),
          ],
        );
      },
    );
  }

  getListOfUserIDsToPotentiallyPromote(Chart chart) {
    List<String> usersToPotentiallyPromote = List.empty(growable: true);
    usersToPotentiallyPromote.addAll(chart.editorIDs);
    usersToPotentiallyPromote.addAll(chart.viewerIDs);
    return usersToPotentiallyPromote;
  }

  Future<void> showUserPromotionConfirmDialog(
      BuildContext context,
      int currTabNum,
      String currUserId,
      Chart currChart,
      bool shouldRemoveCurrUser,
      {String message =
          'You are the only owner of the chart. You will need to choose someone to own the chart.'}) async {
    List<String> ids = getListOfUserIDsToPotentiallyPromote(currChart);
    String currChartID = currChart.id;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chart Ownership'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
                await showUserPromotionUserOptions(
                  context,
                  currTabNum,
                  ids,
                  currChartID,
                  currUserId,
                  currChart,
                );
                if (shouldRemoveCurrUser) {
                  removeCurrUserFromChart(
                    currTabNum,
                    currUserId,
                    currChartID,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  bool isOwner(Chart chart, String userID) {
    return chart.ownerIDs.isNotEmpty && chart.ownerIDs.contains(userID);
  }

  bool isSoleOwner(Chart chart, String userID) {
    return (isOwner(chart, userID) && chart.ownerIDs.length == 1);
  }

  bool isOnlyOneInChart(Chart chart, String userID) {
    int numInChart = 0;
    numInChart += chart.viewerIDs.length;
    numInChart += chart.editorIDs.length;
    numInChart += chart.ownerIDs.length;
    debugPrint(numInChart.toString());
    return (numInChart == 1);
  }

  void processUserPromotionRequest(
      UserModel userToPromote,
      UserModel currLoggedInUser,
      int tabIndex,
      String chartID,
      Chart chartData) async {
    if (userToPromote == UserModel.emptyUser) {
      Global.makeSnackbar("ERROR: Unable to promote user (blank user object)");
      return;
    }
    setUserAsOwner(userToPromote.id,
        ListenService.chartsNotifiers.elementAt(tabIndex).value, chartID);
  }

  void removeCurrUserFromChart(
      int currTabNum, String currUserId, String currChartID) {
    ChartDao.removeListener(currTabNum);
    ChartDao().removeUserIDFromChart(currUserId, currChartID);
    UserDao().removeChartIDForUser(currChartID, currUserId);
    UserDao().removeTabNumToUser(currTabNum, currUserId);
    ListenService.chartsNotifiers[0].value = Chart.emptyChart;
  }

  Future<void> showUserPromotionUserOptions(
    BuildContext context,
    int currTabNum,
    List<String> userIDsToPotentiallyPromote,
    String currChartID,
    String currUserID,
    Chart currChart,
  ) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return GiveOwnershipPopup(
          userIDs: userIDsToPotentiallyPromote,
          index: currTabNum,
          currChartID: currChartID,
          currChart: currChart,
        );
      },
    );
  }

  Future<void> leaveChart(
    BuildContext context,
    int currTabNum,
    String userID,
    String chartID,
    Chart currChart,
  ) async {
    Chart currChart = ListenService.chartsNotifiers.elementAt(currTabNum).value;
    if (isOnlyOneInChart(currChart, userID)) {
      showDeleteChartConfirmDialog(context, currChart, userID,
          message:
              "Since you are the only one in this chart, leaving it will mean that it is deleted. Is that OK?");
      return;
    } else if (isSoleOwner(currChart, userID)) {
      await showUserPromotionConfirmDialog(
          context, currTabNum, userID, currChart, true);
      return;
    }

    debugPrint("Removing this user as owner");

    ChartDao.removeListener(currTabNum);
    ChartDao().removeUserIDFromChart(userID, chartID);
    UserDao().removeChartIDForUser(chartID, userID);
    UserDao().removeTabNumToUser(currTabNum, userID);
    ListenService.chartsNotifiers[0].value = Chart.emptyChart;
  }

  // Remove User from other lists
  // add User to correct list
  void setUserAsOwner(String userID, Chart chart, String chartID) async {
    if (chart == Chart.emptyChart) {
      debugPrint("Chart is empty [not full of data from database");
    }
    if (chart.pendingIDs.contains(userID)) {
      chartDao.updateList("pendingIDs", userID, chart.id, ListAction.REMOVE);
    } else if (chart.viewerIDs.contains(userID)) {
      chartDao.updateList("viewerIDs", userID, chart.id, ListAction.REMOVE);
    } else if (chart.editorIDs.contains(userID)) {
      chartDao.updateList("editorIDs", userID, chart.id, ListAction.REMOVE);
    }
    chartDao.updateList("ownerIDs", userID, chart.id, ListAction.ADD);
    return;
  }

  // Remove User from other lists
  // add User to correct list
  void setUserRoleForChart(String newRole, String userID, Chart chart,
      bool isJoiningChart, int index, String chartID) async {
    if (chart == Chart.emptyChart) {
      debugPrint("Chart is empty [not full of data from database");
    }

    String propertyToChange = "";
    if (newRole == "Remove") {
      if (chart.pendingIDs.contains(userID)) {
        chartDao.updateList("pendingIDs", userID, chart.id, ListAction.REMOVE);
      } else if (chart.viewerIDs.contains(userID)) {
        chartDao.updateList("viewerIDs", userID, chart.id, ListAction.REMOVE);
      } else if (chart.editorIDs.contains(userID)) {
        chartDao.updateList("editorIDs", userID, chart.id, ListAction.REMOVE);
      } else if (chart.ownerIDs.contains(userID)) {
        chartDao.updateList("ownerIDs", userID, chart.id, ListAction.REMOVE);
      }
      UserDao().updateList("chartIDs", chart.id, userID, ListAction.REMOVE);
      UserDao()
          .updateList("associatedTabNums", index, userID, ListAction.REMOVE);
      return;
    }

    if (newRole == "Viewer") {
      propertyToChange = "viewerIDs";
      await chartDao.updateList(
          propertyToChange, userID, chartID, ListAction.ADD);
      if (chart.editorIDs.contains(userID)) {
        await chartDao.updateList(
            "editorIDs", userID, chart.id, ListAction.REMOVE);
      } else if (chart.ownerIDs.contains(userID)) {
        await chartDao.updateList(
            "ownerIDs", userID, chart.id, ListAction.REMOVE);
      }
    } else if (newRole == "Editor") {
      propertyToChange = "editorIDs";
      await chartDao.updateList(
          propertyToChange, userID, chartID, ListAction.ADD);
      if (chart.viewerIDs.contains(userID)) {
        await chartDao.updateList(
            "viewerIDs", userID, chart.id, ListAction.REMOVE);
      } else if (chart.ownerIDs.contains(userID)) {
        await chartDao.updateList(
            "ownerIDs", userID, chart.id, ListAction.REMOVE);
      }
    } else if (newRole == "Owner") {
      propertyToChange = "ownerIDs";
      await chartDao.updateList(
          propertyToChange, userID, chartID, ListAction.ADD);
      if (chart.viewerIDs.contains(userID)) {
        await chartDao.updateList(
            "viewerIDs", userID, chart.id, ListAction.REMOVE);
      } else if (chart.editorIDs.contains(userID)) {
        await chartDao.updateList(
            "editorIDs", userID, chart.id, ListAction.REMOVE);
      }
    } else {
      debugPrint("ERROR");
    }

    if (isJoiningChart) {
      if (chart.pendingIDs.contains(userID)) {
        chartDao.updateList("pendingIDs", userID, chart.id, ListAction.REMOVE);
        UserDao().updateList("chartIDs", chart.id, userID, ListAction.ADD);
        UserDao()
            .updateList("associatedTabNums", index, userID, ListAction.ADD);
      }
    }
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

  void processChartJoinRequest(
      Chart chartToJoin, UserModel currUser, int index) async {
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
      await UserDao().addTabNumToUser(index, currUser.id);
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
