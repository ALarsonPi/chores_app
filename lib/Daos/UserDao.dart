import 'package:chore_app/Daos/ParentDao.dart';
import 'package:chore_app/Models/frozen/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDao extends ParentDao {
  static final CollectionReference currUserCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  CollectionReference<Object?> getCollection() {
    return currUserCollection;
  }

  DocumentReference getUserDocByID(String id) {
    return currUserCollection.doc(id);
  }

  Future<UserModel> getUserByID(String id) async {
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

  Future<void> addUser(UserModel currUser) async {
    currUser = currUser.copyWith(
      email: currUser.email!.toLowerCase(),
    );
    await currUserCollection.doc(currUser.id).set(
        currUser.toJson(),
        SetOptions(
          merge: true,
        ));
  }

  Stream<List<UserModel>> getUserDataViaStream(String firebaseAuthID) {
    Query isUser = currUserCollection.where("id", isEqualTo: firebaseAuthID);
    Stream<List<UserModel>> userStream = isUser.snapshots().map((snapShot) =>
        snapShot.docs
            .map((document) => UserModel.fromSnapshot(document))
            .toList());
    return userStream;
  }

  Future<void> updateUserInFirebase(UserModel currUser) async {
    await currUserCollection.doc(currUser.id).update(
          currUser.toJson(),
        );
  }

  void deleteUser(UserModel currUser) async {
    await currUserCollection.doc(currUser.id).delete();
  }

  Future<UserModel> getCurrUser(String email) async {
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

  Future<void> addTabNumToUser(int newTabNum, String userID) async {
    await updateList('associatedTabNums', newTabNum, userID, ListAction.ADD);
  }

  Future<void> removeTabNumToUser(int newTabNum, String userID) async {
    await updateList('associatedTabNums', newTabNum, userID, ListAction.REMOVE);
  }

  Future<void> addChartIDForUser(String chartID, String userID) async {
    await updateList('chartIDs', chartID, userID, ListAction.ADD);
  }

  Future<void> removeChartIDForUser(String chartID, String userID) async {
    await updateList('chartIDs', chartID, userID, ListAction.REMOVE);
  }
}
