import 'package:chore_app/AppRouter.dart';
import 'package:chore_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Global.dart';
import 'app/app.dart';
import 'app/app.locator.dart';

/// @nodoc
void main() async {
  // Setting the App as Vertical Only
  // Landscape is Disabled
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final prefs = await SharedPreferences.getInstance();
  int? darkModeIndex = prefs.getInt(Settings.darkModeString);
  Global.settings.darkModeIndex = (darkModeIndex != null) ? darkModeIndex : 0;
  int? primaryColorIndex = prefs.getInt(Settings.primaryColorString);
  Global.settings.primaryColorIndex =
      (primaryColorIndex != null) ? primaryColorIndex : 0;
  int? numChartsToShow = prefs.getInt(Settings.numChartsString);
  Global.settings.numChartsToShow =
      (numChartsToShow != null) ? numChartsToShow : 2;

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setupLocator();
  runApp(
      //
      const TheApp()
      // const AppRouter()
      );
}
