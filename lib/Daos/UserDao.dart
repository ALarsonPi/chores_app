import 'package:chore_app/Models/frozen/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserDao {
  static final CollectionReference currUserCollection =
      FirebaseFirestore.instance.collection('users');

  static Future<void> addUser(User currUser) async {
    currUser = currUser.copyWith(
      email: currUser.email!.toLowerCase(),
    );
    await currUserCollection.doc(currUser.id).set(
        currUser.toJson(),
        SetOptions(
          merge: true,
        ));
  }

  static User addChartIDToUser(
      User currUser, String newChartID, int chartTabNum) {
    List<String> userChartIds = List.empty(growable: true);
    if (currUser.chartIDs != null) {
      userChartIds.addAll(currUser.chartIDs as Iterable<String>);
    }
    List<int> tabNums = List.empty(growable: true);
    if (currUser.associatedTabNums != null) {
      tabNums.addAll(currUser.associatedTabNums as Iterable<int>);
    }

    userChartIds.add(newChartID);
    tabNums.add(chartTabNum);

    User updatedUser = currUser.copyWith(
      chartIDs: userChartIds,
      associatedTabNums: tabNums,
    );
    updateUserInFirebase(updatedUser);
    return updatedUser;
  }

  static User removeChartIDForUser(
      User currUser, String oldChartID, int oldTabNum) {
    // ChartIds and TabNums for User should never be
    // empty when delete on a chart is called
    List<String> userChartIds = List.empty(growable: true);

    if (currUser.chartIDs != null) {
      userChartIds.addAll(currUser.chartIDs as Iterable<String>);
    }

    List<int> tabNums = List.empty(growable: true);
    if (currUser.associatedTabNums != null) {
      tabNums.addAll(currUser.associatedTabNums as Iterable<int>);
    }

    userChartIds.remove(oldChartID);
    tabNums.remove(oldTabNum);

    User updatedUser = currUser.copyWith(
      chartIDs: userChartIds,
      associatedTabNums: tabNums,
    );
    updateUserInFirebase(updatedUser);
    return updatedUser;
  }

  static void updateUserInFirebase(User currUser) async {
    await currUserCollection.doc(currUser.id).update(
          currUser.toJson(),
        );
  }

  static void deleteUser(User currUser) async {
    await currUserCollection.doc(currUser.id).delete();
  }

  static Future<User> getCurrUser(String email) async {
    User userFromDatabase = User(id: "ID");
    await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: email.toLowerCase())
        .limit(1)
        .get()
        .then((QuerySnapshot value) => {
              if (value.docs.isNotEmpty)
                userFromDatabase = User.fromSnapshot(value.docs.elementAt(0)),
            });
    return userFromDatabase;
  }
}
