import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  static String tag = 'login-page';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final logo = Hero(
    tag: 'hero',
    child: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 48.0,
      child: Image.asset('assets/logo.png'),
    ),
  );

  final email = TextFormField(
    keyboardType: TextInputType.emailAddress,
    autofocus: true,
    initialValue: '',
    decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        )),
  );

  final password = TextFormField(
    // keyboardType: TextInputType.visiblePassword,
    obscureText: true,
    autofocus: false,
    initialValue: '',
    decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        )),
  );

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
