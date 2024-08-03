import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chore_app/Global.dart';
import 'package:chore_app/Screens/NotificationRegistrationScreen.dart';
// import 'package:chore_app/Screens/homeScreen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:page_transition/page_transition.dart';

/// @nodoc
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    Global.dataTransferComplete = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: AnimatedSplashScreen(
          splash: 'assets/images/AlpsLogoBlue.png',
          pageTransitionType: PageTransitionType.fade,
          nextScreen: const NotificationRegistrationScreen(),
          duration: 2200,
          splashIconSize: 700,
          splashTransition: SplashTransition.fadeTransition),
    );
  }
}
