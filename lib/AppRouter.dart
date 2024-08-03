import 'package:chore_app/Providers/TabNumberProvider.dart';
import 'package:chore_app/Providers/TextSizeProvider.dart';
import 'package:chore_app/Providers/ThemeProvider.dart';
import 'package:chore_app/Screens/ChartScreen.dart';
import 'package:chore_app/Screens/ConnectedUsersScreen.dart';
import 'package:chore_app/Screens/NotificationRegistrationScreen.dart';
import 'package:chore_app/Screens/SettingsScreen.dart';
import 'package:chore_app/Screens/homeScreen.dart';
import 'package:chore_app/Services/Notifications/NotificationActionService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ColorControl/GlobalThemes.dart';
import 'Global.dart';
import 'Screens/SplashScreen.dart';

/// @nodoc
class AppRouter extends StatefulWidget {
  const AppRouter({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AppRouter();
  }
}

class _AppRouter extends State<AppRouter> {
  setDefaultTextSize(BuildContext context) {
    Global.didUpdate = true;
    Provider.of<TextSizeProvider>(context, listen: false)
        .setCurrTextSize(Global.getCurrTextSize());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final navigatorKey = GlobalKey<NavigatorState>();

  final notificationActionService = NotificationActionService();

  Future<void> showActionAlert({message = String}) async {
    return showDialog<void>(
      context: navigatorKey.currentState!.overlay!.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification Demo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Global.dataTransferComplete = false;
    return MultiProvider(
      providers: [
        // Light / Dark Mode as well as Primary Color
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        // To remember which tab currently on
        // and control number of tabs available
        ChangeNotifierProvider(
          create: (_) => TabNumberProvider(),
        ),
        // To change text size throughout the app
        ChangeNotifierProvider(
          create: (_) => TextSizeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          if (!Global.didUpdate) setDefaultTextSize(context);
          return GestureDetector(
            onTap: () => {
              if (Global.titleFocusNode.hasFocus)
                {
                  Global.titleFocusNode.unfocus(),
                  if (Global.changeTitleWidgetKey.currentState != null)
                    {
                      Global.changeTitleWidgetKey.currentState!.updateParent(),
                    }
                },
            },
            child: MaterialApp(
              scaffoldMessengerKey: Global.rootScaffoldMessengerKey,
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              themeMode: themeProvider.selectedThemeMode,
              theme:
                  GlobalThemes.getThemeData(themeProvider.isDarkMode, context),
              darkTheme:
                  GlobalThemes.getThemeData(themeProvider.isDarkMode, context),
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
                '/': (context) => const SplashScreen(),
                ConnectedUsersScreen.routeName: (context) =>
                    const ConnectedUsersScreen(),
                ChartScreen.routeName: (context) => const ChartScreen(),
                'home': (context) => HomeScreen(),
                'settings': (context) => const SettingsScreen(),
                'notification-registration': (context) =>
                    const NotificationRegistrationScreen()
              },
            ),
          );
        },
      ),
    );
  }
}
