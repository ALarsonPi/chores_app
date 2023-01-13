import 'package:chore_app/Providers/ChartProvider.dart';
import 'package:chore_app/Providers/CurrUserProvider.dart';
import 'package:chore_app/Providers/TabNumberProvider.dart';
import 'package:chore_app/Providers/TextSizeProvider.dart';
import 'package:chore_app/Providers/ThemeProvider.dart';
import 'package:chore_app/Screens/ScreenArguments/newChartArguments.dart';
import 'package:chore_app/Screens/createChartScreen.dart';
import 'package:chore_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ColorControl/GlobalThemes.dart';
import 'Daos/ChartDao.dart';
import 'Global.dart';
import 'Models/ChartDataHolder.dart';
import 'Models/frozen/Chart.dart';
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

  late Future _dataFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dataFuture =
        fetchUsersCharts(FirebaseAuth.instance.currentUser?.uid as String);
  }

  Future<List<ChartDataHolder>> fetchUsersCharts(String currUserID) async {
    List<ChartDataHolder> currChartData = await ChartDao.getCharts(currUserID);
    for (int i = 0; i < Global.TABS_ALLOWED; i++) {
      bool isFound = false;
      for (int j = 0; j < currChartData.length; j++) {
        if (currChartData.elementAt(j).index == i) {
          Global.chartHolderGlobal.add(currChartData.elementAt(j).actualChart);
          isFound = true;
          break;
        }
      }
      if (!isFound) Global.chartHolderGlobal.add(Chart.emptyChart);
    }

    return currChartData;
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
      child: Consumer<ChartProvider>(
        builder: (c, value, child) => FutureBuilder(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(),
              );
            } else {
              return Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  if (!Global.didUpdate) setDefaultTextSize(context);
                  return GestureDetector(
                    onTap: () => {
                      if (Global.titleFocusNode.hasFocus)
                        {
                          Global.titleFocusNode.unfocus(),
                          if (Global.changeTitleWidgetKey.currentState != null)
                            {
                              Global.changeTitleWidgetKey.currentState!
                                  .updateParent(),
                            }
                        },
                    },
                    child: MaterialApp(
                      scaffoldMessengerKey: Global.rootScaffoldMessengerKey,
                      debugShowCheckedModeBanner: false,
                      themeMode: themeProvider.selectedThemeMode,
                      theme: GlobalThemes.getThemeData(
                          themeProvider.isDarkMode, context),
                      darkTheme: GlobalThemes.getThemeData(
                          themeProvider.isDarkMode, context),
                      title: 'Custom Chore Chart',
                      builder: (context, widget) => Navigator(
                        onGenerateRoute: (RouteSettings settings) =>
                            MaterialPageRoute(
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
              );
            }
          },
        ),
      ),
    );
  }
}
