import 'dart:convert';
import 'dart:io';
import 'dart:math';
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';

import 'package:chore_app/Daos/UserDao.dart';
import 'package:chore_app/Global.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../Models/frozen/UserModel.dart';

class CurrUserProvider extends ChangeNotifier {
  UserModel currUser = UserModel(id: "ID");

  // Used on Register
  setCurrUser(UserModel newUser) {
    if (currUser == newUser) return;
    currUser = newUser.copyWith(
        id: newUser.id,
        name: newUser.name,
        email: newUser.email,
        password: newUser.password);
    notifyListeners();
  }

  addChartIDToUser(String newChartID, int newTabNum) async {
    UserModel user =
        await UserDao.addChartIDToUser(currUser, newChartID, newTabNum);
    currUser = user;
  }

  deleteChartIDForUser(String oldChartID, int oldTabNum) {
    UserModel user =
        UserDao.removeChartIDForUser(currUser, oldChartID, oldTabNum);
    currUser = user;
  }

  isEmailBeingUsedByOtherProvider(String proposedEmail) async {
    bool emailIsInUse = await isEmailAlreadyInUse(proposedEmail);
    if (emailIsInUse) {
      List availableTypes = await getListOfAvailableSignInTypes(proposedEmail);
      makeSnackBarWithText(
          "Account already made with that email. Try signing in with ${availableTypes.first}");
    }
    return emailIsInUse;
  }

  register(String fullName, String email, String password) async {
    if (await isEmailBeingUsedByOtherProvider(email)) return;
    try {
      await firebase.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.toLowerCase(),
        password: password,
      );
      await _addUser(firebase.FirebaseAuth.instance.currentUser?.uid as String,
          fullName, email.toLowerCase(), password);
    } on auth.FirebaseAuthException catch (e) {
      makeSnackBarWithText(e.message.toString());
    }
  }

  login(String email, String password) async {
    try {
      await firebase.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.toLowerCase(),
        password: password,
      );
      getCurrUser(email);
    } on auth.FirebaseAuthException catch (e) {
      makeSnackBarWithText(e.message.toString());
    }
  }

  // Used on Sign-in and refresh
  Future<UserModel> getCurrUser(String email) async {
    UserModel newUser = await UserDao.getCurrUser(email);
    if (currUser == newUser) return currUser;
    currUser = newUser;
    Global.currUserID = currUser.id;
    notifyListeners();
    return currUser;
  }

  void signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken == null || googleAuth?.idToken == null) {
        throw auth.FirebaseAuthException(
          code: "Null",
          message: "Google sign-in incomplete",
        );
      }

      // Create a new credential
      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      auth.UserCredential currUser =
          await auth.FirebaseAuth.instance.signInWithCredential(credential);

      await _addUser(
          firebase.FirebaseAuth.instance.currentUser?.uid as String,
          currUser.user?.displayName,
          currUser.user?.email?.toLowerCase(),
          null);
    } on auth.FirebaseAuthException catch (e) {
      makeSnackBarWithText(e.message.toString());
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance
          .login(permissions: ["public_profile", "email"]);

      if (loginResult.accessToken?.token == null) {
        throw auth.FirebaseAuthException(
          code: "Null",
          message: "Facebook sign-in incomplete",
        );
      }

      // Create a credential from the access token
      final auth.OAuthCredential facebookAuthCredential =
          auth.FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      auth.UserCredential currUser = await auth.FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      await _addUser(
          firebase.FirebaseAuth.instance.currentUser?.uid as String,
          currUser.user?.displayName,
          currUser.user?.email?.toLowerCase(),
          null);
    } on auth.FirebaseAuthException catch (e) {
      makeSnackBarWithText(e.message.toString());
    }
  }

  Future<List> getListOfAvailableSignInTypes(String emailAddress) async {
    try {
      // Fetch sign-in methods for the email address
      final list = await auth.FirebaseAuth.instance
          .fetchSignInMethodsForEmail(emailAddress);
      return list;
    } on auth.FirebaseAuthException catch (e) {
      makeSnackBarWithText(e.message.toString());
      return List.empty(growable: true);
    }
  }

  // Returns true if email address is in use.
  Future<bool> isEmailAlreadyInUse(String emailAddress) async {
    try {
      // Fetch sign-in methods for the email address
      final list = await auth.FirebaseAuth.instance
          .fetchSignInMethodsForEmail(emailAddress);

      // In case list is not empty
      if (list.isNotEmpty) {
        // Return true because there is an existing
        // UserModel using the email address
        return true;
      } else {
        // Return false because email adress is not in use
        return false;
      }
    } on auth.FirebaseAuthException catch (e) {
      makeSnackBarWithText(e.message.toString());
      return true;
    }
  }

  void signInWithApple() async {
    try {
      // final rawNonce = generateNonce();
      // final nonce = sha256ofString(rawNonce);
      // final credential = await SignInWithApple.getAppleIDCredential(
      //   scopes: [
      //     AppleIDAuthorizationScopes.email,
      //     AppleIDAuthorizationScopes.fullName,
      //   ],
      //   nonce: nonce,
      // );

      auth.AppleAuthProvider provider = auth.AppleAuthProvider();
      provider.addScope('email');
      provider.addScope('fullName');

      auth.UserCredential currUser;
      if (!Platform.isAndroid && !Platform.isIOS) {
        currUser = await auth.FirebaseAuth.instance.signInWithPopup(provider);
      } else {
        currUser =
            await auth.FirebaseAuth.instance.signInWithProvider(provider);
      }
      await _addUser(
          firebase.FirebaseAuth.instance.currentUser?.uid as String,
          currUser.user?.displayName,
          currUser.user?.email?.toLowerCase(),
          null);
    } on auth.FirebaseAuthException catch (e) {
      String messageToShow = e.message.toString();
      if (e.code == "canceled") {
        messageToShow = "Apple sign-in incomplete";
      }
      makeSnackBarWithText(messageToShow);
    }
  }

  Future<bool> passwordReset(String email) async {
    try {
      await auth.FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.toLowerCase());
      return true;
    } on auth.FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      makeSnackBarWithText(e.message.toString());
      return false;
    }
  }

  _addUser(String id, String? fullName, String? email, String? password) async {
    UserModel newUser = UserModel(
      id: id,
      name: fullName,
      email: email?.toLowerCase(),
      password: password,
    );
    setCurrUser(newUser);
    await UserDao.addUser(newUser);
  }
}

makeSnackBarWithText(String message) {
  Global.makeSnackbar(
    message.toString(),
  );
}
