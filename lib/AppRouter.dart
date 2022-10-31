import 'package:flutter/material.dart';
import 'Screens/SplashScreen.dart';

/// @nodoc
class AppRouter extends StatelessWidget {
  const AppRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom Chore Chart',
      builder: (context, widget) => Navigator(
        onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
          builder: (ctx) {
            return Container(
              child: widget,
            );
          },
        ),
      ),
      initialRoute: '/',
      routes: {
        //Global
        '/': (context) => const SplashScreen(),
      },
    );
  }
}
