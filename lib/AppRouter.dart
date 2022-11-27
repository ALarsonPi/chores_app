import 'package:chore_app/Providers/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ColorControl/GlobalThemes.dart';
import 'Global.dart';
import 'Screens/SplashScreen.dart';

/// @nodoc
class AppRouter extends StatelessWidget {
  const AppRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.selectedThemeMode,
            theme: GlobalThemes.getThemeData(themeProvider.isDarkMode),
            darkTheme: GlobalThemes.getThemeData(themeProvider.isDarkMode),
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
        },
      ),
    );
  }
}
