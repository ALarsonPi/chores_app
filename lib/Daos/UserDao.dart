import 'package:chore_app/Daos/ParentDao.dart';
import 'package:chore_app/Models/frozen/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserDao extends ParentDao {
  static final CollectionReference currUserCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  CollectionReference<Object?> getCollection() {
    return currUserCollection;
  }

  static DocumentReference getUserDocByID(String id) {
    return currUserCollection.doc(id);
  }

  static Future<UserModel> getUserByID(String id) async {
    UserModel UserModelFromDatabase = UserModel.emptyUser;
    await currUserCollection
        .where("id", isEqualTo: id)
        .limit(1)
        .get()
        .then((QuerySnapshot value) => {
              if (value.docs.isNotEmpty)
                {
                  UserModelFromDatabase =
                      UserModel.fromSnapshot(value.docs.elementAt(0)),
                }
            });
    return UserModelFromDatabase;
  }

  static Future<void> addUser(UserModel currUser) async {
    currUser = currUser.copyWith(
      email: currUser.email!.toLowerCase(),
    );
    await currUserCollection.doc(currUser.id).set(
        currUser.toJson(),
        SetOptions(
          merge: true,
        ));
  }

  static Stream<List<UserModel>> getUserDataViaStream(String firebaseAuthID) {
    Query isUser = currUserCollection.where("id", isEqualTo: firebaseAuthID);
    Stream<List<UserModel>> userStream = isUser.snapshots().map((snapShot) =>
        snapShot.docs
            .map((document) => UserModel.fromSnapshot(document))
            .toList());
    return userStream;
  }

  static Future<UserModel> addChartIDToUser(
      UserModel currUser, String newChartID, int chartTabNum) async {
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

    UserModel updatedUser = currUser.copyWith(
      chartIDs: userChartIds,
      associatedTabNums: tabNums,
    );
    await updateUserInFirebase(updatedUser);
    return updatedUser;
  }

  static UserModel removeChartIDForUser(
      UserModel currUser, String oldChartID, int oldTabNum) {
    // ChartIds and TabNums for UserModel should never be
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

    UserModel updatedUser = currUser.copyWith(
      chartIDs: userChartIds,
      associatedTabNums: tabNums,
    );
    updateUserInFirebase(updatedUser);
    return updatedUser;
  }

  static Future<void> updateUserInFirebase(UserModel currUser) async {
    await currUserCollection.doc(currUser.id).update(
          currUser.toJson(),
        );
  }

  static void deleteUser(UserModel currUser) async {
    await currUserCollection.doc(currUser.id).delete();
  }

  static Future<UserModel> getCurrUser(String email) async {
    UserModel userFromDatabase = UserModel(id: "ID");
    await currUserCollection
        .where("email", isEqualTo: email.toLowerCase())
        .limit(1)
        .get()
        .then((QuerySnapshot value) => {
              if (value.docs.isNotEmpty)
                {
                  userFromDatabase =
                      UserModel.fromSnapshot(value.docs.elementAt(0)),
                }
            });
    return userFromDatabase;
  }
}
