import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

import '../../../../Models/User.dart';
import '../../../../api/firestore_api.dart';
import '../../../../app/app.locator.dart';

class UserService {
  final _firestoreApi = locator<FirestoreApi>();
  final _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  User? _currentUser;

  User get currentUser => _currentUser!;
  bool get hasLoggedInUser => _firebaseAuthenticationService.hasUser;

  Future<void> syncUserAccount() async {
    final firebaseUserId =
        _firebaseAuthenticationService.firebaseAuth.currentUser!.uid;

    final userAccount = await _firestoreApi.getUser(userId: firebaseUserId);

    if (userAccount != null) {
      _currentUser = userAccount;
    }
  }

  Future<void> syncOrCreateUserAccount({required User user}) async {
    await syncUserAccount();

    if (_currentUser == null) {
      await _firestoreApi.createUser(user: user);
      _currentUser = user;
    }
  }
}
