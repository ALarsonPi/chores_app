import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Used to get ssa key and nonce for apple
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';

import '../Daos/UserDao.dart';
import '../Global.dart';
import '../Models/frozen/UserModel.dart';

class FirebaseLogin {
  static isEmailBeingUsedByOtherProvider(String proposedEmail) async {
    bool emailIsInUse = await isEmailAlreadyInUse(proposedEmail);
    if (emailIsInUse) {
      List availableTypes = await getListOfAvailableSignInTypes(proposedEmail);
      makeSnackBarWithText(
          "Account already made with that email. Try signing in with ${availableTypes.first}");
    }
    return emailIsInUse;
  }

  static register(String fullName, String email, String password) async {
    if (await isEmailBeingUsedByOtherProvider(email)) return;
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.toLowerCase(),
        password: password,
      );
      await _addUser(FirebaseAuth.instance.currentUser?.uid as String, fullName,
          email.toLowerCase(), password);
    } on FirebaseAuthException catch (e) {
      makeSnackBarWithText(e.message.toString());
    }
  }

  static login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.toLowerCase(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      makeSnackBarWithText(e.message.toString());
    }
  }

  static void signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken == null || googleAuth?.idToken == null) {
        throw FirebaseAuthException(
          code: "Null",
          message: "Google sign-in incomplete",
        );
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential currUser =
          await FirebaseAuth.instance.signInWithCredential(credential);

      await _addUser(
          FirebaseAuth.instance.currentUser?.uid as String,
          currUser.user?.displayName,
          currUser.user?.email?.toLowerCase(),
          null);
    } on FirebaseAuthException catch (e) {
      makeSnackBarWithText(e.message.toString());
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  static String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static void signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance
          .login(permissions: ["public_profile", "email"]);

      if (loginResult.accessToken?.token == null) {
        throw FirebaseAuthException(
          code: "Null",
          message: "Facebook sign-in incomplete",
        );
      }

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      UserCredential currUser = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      await _addUser(
          FirebaseAuth.instance.currentUser?.uid as String,
          currUser.user?.displayName,
          currUser.user?.email?.toLowerCase(),
          null);
    } on FirebaseAuthException catch (e) {
      makeSnackBarWithText(e.message.toString());
    }
  }

  static Future<List> getListOfAvailableSignInTypes(String emailAddress) async {
    try {
      // Fetch sign-in methods for the email address
      final list =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailAddress);
      return list;
    } on FirebaseAuthException catch (e) {
      makeSnackBarWithText(e.message.toString());
      return List.empty(growable: true);
    }
  }

  // Returns true if email address is in use.
  static Future<bool> isEmailAlreadyInUse(String emailAddress) async {
    try {
      // Fetch sign-in methods for the email address
      final list =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailAddress);

      // In case list is not empty
      if (list.isNotEmpty) {
        // Return true because there is an existing
        // UserModel using the email address
        return true;
      } else {
        // Return false because email adress is not in use
        return false;
      }
    } on FirebaseAuthException catch (e) {
      makeSnackBarWithText(e.message.toString());
      return true;
    }
  }

  static void signInWithApple() async {
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

      AppleAuthProvider provider = AppleAuthProvider();
      provider.addScope('email');
      provider.addScope('fullName');

      UserCredential currUser;
      if (!Platform.isAndroid && !Platform.isIOS) {
        currUser = await FirebaseAuth.instance.signInWithPopup(provider);
      } else {
        currUser = await FirebaseAuth.instance.signInWithProvider(provider);
      }
      await _addUser(
          FirebaseAuth.instance.currentUser?.uid as String,
          currUser.user?.displayName,
          currUser.user?.email?.toLowerCase(),
          null);
    } on FirebaseAuthException catch (e) {
      String messageToShow = e.message.toString();
      if (e.code == "canceled") {
        messageToShow = "Apple sign-in incomplete";
      }
      makeSnackBarWithText(messageToShow);
    }
  }

  static Future<bool> passwordReset(String email) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.toLowerCase());
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      makeSnackBarWithText(e.message.toString());
      return false;
    }
  }

  static _addUser(
      String id, String? fullName, String? email, String? password) async {
    UserModel newUser = UserModel(
      id: id,
      name: fullName,
      email: email?.toLowerCase(),
      password: password,
    );
    await UserDao.addUser(newUser);
  }

  static makeSnackBarWithText(String message) {
    Global.makeSnackbar(
      message.toString(),
    );
  }
}
