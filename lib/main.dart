import 'dart:math';
import 'package:chore_app/AppRouter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// @nodoc
void main() {
  // Setting the App as Vertical Only
  // Landscape is Disabled
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));
  runApp(const AppRouter());
}
