import 'package:chore_app/Screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

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
    //Contact Firebase to get Stuff if needed
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: AnimatedSplashScreen(
          splash: 'assets/images/TheAlpsCreations.png',
          pageTransitionType: PageTransitionType.fade,
          nextScreen: HomeScreen(),
          duration: 2200,
          splashIconSize: 500,
          splashTransition: SplashTransition.fadeTransition),
    );
  }
}