import 'package:chore_app/Daos/UserDao.dart';
import 'package:chore_app/Global.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';

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
    await firebase.FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.toLowerCase(),
      password: password,
    );
    User newUser = User(
      id: firebase.FirebaseAuth.instance.currentUser?.uid as String,
      name: fullName,
      email: email.toLowerCase(),
      password: password,
    );
    setCurrUser(newUser);
    await UserDao.addUser(newUser);
    firebase.FirebaseAuth.instance.currentUser?.uid as String;
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
}
