import 'dart:async';

import 'package:chore_app/Daos/UserDao.dart';
import 'package:chore_app/Global.dart';
import 'package:chore_app/Models/frozen/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserManager {
  ValueNotifier<UserModel> currUser =
      ValueNotifier<UserModel>(UserModel.emptyUser);
  late StreamSubscription userListener;

  Future<UserModel> addListener(String id) async {
    final DocumentReference docRef = UserDao.getUserDocByID(id);
    UserModel updatedUser = await UserDao.getUserByID(id);
    var subscription = docRef.snapshots().listen((event) {
      // Listening to changes to user
      // debugPrint("Setting User to " + UserModel.fromSnapshot(event).toString());

      Global.getIt.get<UserManager>().currUser.value =
          UserModel.fromSnapshot(event);
      return;
    });
    userListener = subscription;
    return updatedUser;
  }

  endListening() {
    debugPrint("Canceling user listener");
    userListener.cancel();
  }

  addChartIDToUser(String newChartID, int newTabNum) async {
    UserModel user =
        await UserDao.addChartIDToUser(currUser.value, newChartID, newTabNum);
    currUser.value = user;
  }

  deleteChartIDForUser(String oldChartID, int oldTabNum) {
    UserModel user =
        UserDao.removeChartIDForUser(currUser.value, oldChartID, oldTabNum);
    currUser.value = user;
  }

  void addTabToUser(int tabNum, String chartIDToAdd) {
    List<int> currTabs = List.empty(growable: true);
    if (currUser.value.associatedTabNums != null) {
      currTabs.addAll(currUser.value.associatedTabNums as List<int>);
    }
    currTabs.add(tabNum);

    List<String> currIds = List.empty(growable: true);
    if (currUser.value.chartIDs != null) {
      currIds.addAll(currUser.value.chartIDs as List<String>);
    }
    currIds.add(chartIDToAdd);

    currUser.value =
        currUser.value.copyWith(associatedTabNums: currTabs, chartIDs: currIds);
  }

  void removeTabFromUser(int tabNum, String chartID) {
    List<int> currTabs = List.empty(growable: true);
    if (currUser.value.associatedTabNums != null) {
      currTabs.addAll(currUser.value.associatedTabNums as List<int>);
    }
    currTabs.remove(tabNum);

    List<String> currIds = List.empty(growable: true);
    if (currUser.value.chartIDs != null) {
      currIds.addAll(currUser.value.chartIDs as List<String>);
    }
    currIds.remove(chartID);

    currUser.value =
        currUser.value.copyWith(associatedTabNums: currTabs, chartIDs: currIds);
  }
}
