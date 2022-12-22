import 'dart:io';

import 'package:chore_app/Daos/UserDao.dart';
import 'package:chore_app/Global.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../Models/frozen/User.dart';

class CurrUserProvider extends ChangeNotifier {
  User currUser = User(id: "ID");

  // Used on Register
  setCurrUser(User newUser) {
    if (currUser == newUser) return;
    currUser = newUser.copyWith(
        id: newUser.id,
        name: newUser.name,
        email: newUser.email,
        password: newUser.password);
    notifyListeners();
  }

  register(String fullName, String email, String password) async {
    // try {
    //   var googleAuthCredential =
    //       auth.GoogleAuthProvider.credential(accessToken: 'xxxx');

    //   // Attempt to sign in the user in with Google
    //   await auth.FirebaseAuth.instance
    //       .signInWithCredential(googleAuthCredential);
    // } on auth.FirebaseAuthException catch (e) {
    //   if (e.code == 'account-exists-with-different-credential') {
    //     // The account already exists with a different credential
    //     String email = e.email as String;
    //     auth.AuthCredential pendingCredential =
    //         e.credential as auth.AuthCredential;

    //     // Fetch a list of what sign-in methods exist for the conflicting user
    //     List<String> userSignInMethods =
    //         await auth.FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

    //     // If the user has several sign-in methods,
    //     // the first method in the list will be the "recommended" method to use.
    //     if (userSignInMethods.first == 'password') {
    //       // Prompt the user to enter their password
    //       String password = '...';

    //       // Sign the user in to their account with the password
    //       auth.UserCredential userCredential =
    //           await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
    //         email: email,
    //         password: password,
    //       );

    //       // Link the pending credential with the existing account
    //       await userCredential.user?.linkWithCredential(pendingCredential);
    //     }

    //     // Since other providers are now external, you must now sign the user in with another
    //     // auth provider, such as Facebook.
    //     if (userSignInMethods.first == 'facebook.com') {
    //       // Create a new Facebook credential
    //       String accessToken = auth.FacebookAuthCredential as String;
    //       var facebookAuthCredential =
    //           auth.FacebookAuthProvider.credential(accessToken);

    //       // Sign the user in with the credential
    //       auth.UserCredential userCredential = await auth.FirebaseAuth.instance
    //           .signInWithCredential(facebookAuthCredential);

    //       // Link the pending credential with the existing account
    //       await userCredential.user?.linkWithCredential(pendingCredential);
    //     }

    //     // Handle other OAuth providers...like Apple
    //   }
    // }

    await firebase.FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.toLowerCase(),
      password: password,
    );
    await _addUser(firebase.FirebaseAuth.instance.currentUser?.uid as String,
        fullName, email.toLowerCase(), password);
  }

  login(String email, String password) async {
    await firebase.FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.toLowerCase(),
      password: password,
    );
    getCurrUser(email);
  }

  // Used on Sign-in and refresh
  getCurrUser(String email) async {
    User newUser = await UserDao.getCurrUser(email);
    if (currUser == newUser) return;
    currUser = newUser.copyWith(
        name: newUser.name, email: newUser.email, password: newUser.password);
    Global.currUserID = currUser.id;
    notifyListeners();
  }

  void signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    auth.UserCredential currUser =
        await auth.FirebaseAuth.instance.signInWithCredential(credential);

    await _addUser(firebase.FirebaseAuth.instance.currentUser?.uid as String,
        currUser.user?.displayName, currUser.user?.email?.toLowerCase(), null);
  }

  void signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ["public_profile", "email"]);

    // Create a credential from the access token
    final auth.OAuthCredential facebookAuthCredential =
        auth.FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    auth.UserCredential currUser = await auth.FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    await _addUser(firebase.FirebaseAuth.instance.currentUser?.uid as String,
        currUser.user?.displayName, currUser.user?.email?.toLowerCase(), null);
  }

  void signInWithApple() async {
    final appleProvider = auth.AppleAuthProvider();
    auth.UserCredential currUser;
    if (!Platform.isAndroid && !Platform.isIOS) {
      currUser =
          await auth.FirebaseAuth.instance.signInWithPopup(appleProvider);
    } else {
      currUser =
          await auth.FirebaseAuth.instance.signInWithProvider(appleProvider);
    }
    await _addUser(firebase.FirebaseAuth.instance.currentUser?.uid as String,
        currUser.user?.displayName, currUser.user?.email?.toLowerCase(), null);
  }

  Future<bool> passwordReset(String email) async {
    try {
      await auth.FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.toLowerCase());
      return true;
    } on auth.FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      Global.rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
        ),
      );
      return false;
    }
  }

  _addUser(String id, String? fullName, String? email, String? password) async {
    User newUser = User(
      id: id,
      name: fullName,
      email: email?.toLowerCase(),
      password: password,
    );
    setCurrUser(newUser);
    await UserDao.addUser(newUser);
  }
}
