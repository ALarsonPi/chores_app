import 'package:chore_app/Providers/ChartProvider.dart';
import 'package:chore_app/Providers/CurrUserProvider.dart';
import 'package:chore_app/Providers/TabNumberProvider.dart';
import 'package:chore_app/Providers/TextSizeProvider.dart';
import 'package:chore_app/Providers/ThemeProvider.dart';
import 'package:chore_app/Screens/ScreenArguments/newChartArguments.dart';
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

  setDefaultTextSize(BuildContext context) {
    Global.didUpdate = true;
    Provider.of<TextSizeProvider>(context, listen: false)
        .setCurrTextSize(Global.getCurrTextSize());
  }

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
          create: (_) => ChartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CurrUserProvider(),
        ),
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
                // 'Settings': (context) => const SettingsScreen(),
                CreateChartScreen.routeName: (context) =>
                    const CreateChartScreen()
              },
            ),
          );
        },
      ),
    );
  }
}
