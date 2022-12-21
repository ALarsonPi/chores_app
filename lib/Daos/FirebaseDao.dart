import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDao {
  static Future signIn(String emailText, String passwordText) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailText,
      password: passwordText,
    );
  }

  static Future register(
      String fullName, String emailText, String passwordText) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailText,
      password: passwordText,
    );
  }
}
