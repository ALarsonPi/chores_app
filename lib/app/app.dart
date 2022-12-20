import 'package:flutter/material.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

import '../Widgets/UserLoginLogout/AddressSelection/AddressSelectionView.dart';
import '../Widgets/UserLoginLogout/FilledStacksLogin/createAccount/CreateAccountView.dart';
import '../Widgets/UserLoginLogout/FilledStacksLogin/login/LoginView.dart';
import '../Widgets/UserLoginLogout/FilledStacksLogin/services/userService.dart';
import '../Widgets/UserLoginLogout/startup/StartupView.dart';
import '../api/firestore_api.dart';
import 'app.router.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartUpView),
    CupertinoRoute(page: AddressSelectionView),
    CupertinoRoute(page: CreateAccountView),
    CupertinoRoute(page: LoginView, initial: true),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: FirestoreApi),
    Singleton(classType: FirebaseAuthenticationService)
  ],
)
class TheApp extends StatelessWidget {
  const TheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      home: LoginView(),
    );
  }
}
