import 'package:chore_app/Providers/CircleDataProvider.dart';
import 'package:chore_app/Providers/CurrUserProvider.dart';
import 'package:chore_app/Providers/TabNumberProvider.dart';
import 'package:chore_app/Providers/ThemeProvider.dart';
import 'package:chore_app/Screens/ScreenArguments/newChartArguments.dart';
import 'package:chore_app/Screens/SettingsScreen.dart';
import 'package:chore_app/Screens/createChartScreen.dart';
import 'package:chore_app/main.dart';
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
        ChangeNotifierProvider(
          create: (_) => TabNumberProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CircleDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CurrUserProvider(),
        )
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            scaffoldMessengerKey: Global.rootScaffoldMessengerKey,
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
              'Settings': (context) => const SettingsScreen(),
              CreateChartScreen.routeName: (context) =>
                  const CreateChartScreen()
            },
          );
        },
      ),
    );
  }
}
