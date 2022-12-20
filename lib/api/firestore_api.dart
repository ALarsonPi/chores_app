import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestoreAPI_Exception.dart';
import '../Models/User.dart';

class FirestoreApi {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUser({required User user}) async {
    try {
      final userDocument = usersCollection.doc(user.id);
      await userDocument.set(user.toJson());
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to create new user',
        devDetails: '$error',
      );
    }
  }

  Future<User?> getUser({required String userId}) async {
    if (userId.isNotEmpty) {
      final userSnapShot = await usersCollection.doc(userId).get();
      if (!userSnapShot.exists) {
        return null;
      }
      return User.fromSnapshot(userSnapShot);
    } else {
      throw FirestoreApiException(
          message:
              'Your userId passed in is empty. Please pass in a valid user if from your Firebase user.');
    }
  }
}
