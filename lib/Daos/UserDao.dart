import 'package:chore_app/Models/frozen/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  static void updateUser(User currUser) async {
    await currUserCollection.doc(currUser.id).update(currUser.toJson());
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