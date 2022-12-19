import 'package:badges/badges.dart';
import 'package:chore_app/Models/CircleData.dart';
import 'package:chore_app/Providers/CircleDataProvider.dart';
import 'package:chore_app/Providers/TabNumberProvider.dart';
import 'package:chore_app/Widgets/ConcentricChart/ConcentricChart.dart';
import 'package:chore_app/Widgets/UserLoginLogout/LoginWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Global.dart';
import '../Providers/ThemeProvider.dart';
import '../Widgets/Settings/SettingsContent.dart';
import '../Widgets/TabContent.dart';

/// @nodoc
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> with TickerProviderStateMixin {
  late List<CircleData> circleDataList;
  late List<Tab> tabs;
  late List<Tab> tabsToUse;
  late TabController controller;

  bool shouldChangeTab = false;

  @override
  void initState() {
    super.initState();
  }

  void setControllerToFinalTab() {
    controller.index = tabsToUse.length - 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setTabs();

    int numTabs = Provider.of<TabNumberProvider>(context, listen: true).numTabs;
    controller = TabController(length: numTabs + 1, vsync: this);

    tabsToUse = List.empty(growable: true);
    for (int i = 0; i < numTabs; i++) {
      tabsToUse.add(tabs.elementAt(i));
    }
    // Settings Tab
    tabsToUse.add(tabs.last);
    if (shouldChangeTab) {
      setControllerToFinalTab();
    } else {
      controller.index = 0;
      shouldChangeTab = true;
    }
  }

  void setTabs() {
    // THESE WOULD BE GATHERED FROM THE CHARTS
    String chartTitle1 = "Chart 1";
    String chartTitle2 = "Chart 2";
    String chartTitle3 = "Chart 3";
    int chart1Changes = 0;
    int chart2Changes = 0;
    int chart3Changes = 0;

    const Color badgeColor = Colors.red;
    //Theme.of(context).primaryColor,

    const String badgeText = ' ';
    const Color textColor = Colors.white;

    tabs = [
      Tab(
        text: chartTitle1,
        icon: (chart1Changes != 0)
            ? Badge(
                badgeColor: badgeColor,
                badgeContent: const Text(
                  badgeText,
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                child: const Icon(Icons.looks_one),
              )
            : const Icon(Icons.looks_one),
      ),
      Tab(
        text: chartTitle2,
        icon: (chart2Changes != 0)
            ? Badge(
                badgeColor: badgeColor,
                badgeContent: const Text(
                  badgeText,
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                child: const Icon(Icons.looks_two),
              )
            : const Icon(Icons.looks_two),
      ),
      Tab(
        text: chartTitle3,
        icon: (chart3Changes != 0)
            ? Badge(
                badgeColor: badgeColor,
                badgeContent: const Text(
                  badgeText,
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                child: const Icon(Icons.looks_3),
              )
            : const Icon(Icons.looks_3),
      ),
      const Tab(
        text: "Settings",
        icon: Icon(Icons.settings),
      ),
    ];
  }

  Widget getBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
          ),
        ],
        color: Provider.of<ThemeProvider>(context, listen: true).isDarkMode
            ? Theme.of(context).backgroundColor
            : Theme.of(context).primaryColor,
      ),
      child: TabBar(
        controller: controller,
        onTap: (index) => {
          setState(() {
            controller.index = index;
          }),
        },
        isScrollable: false,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white54,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(5.0),
        indicatorColor: Theme.of(context).primaryColor,
        tabs: tabsToUse,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> circle1Text = [
      "John",
      "Jamie",
      "Will",
      "Abby",
      // "Jake",
      // "Johnny",
      // "Santa",
      // "Abe"
    ];

    List<String> circle2Text = [
      "Clean/Clear Table",
      "Pots/Pans",
      "Dishwasher",
      "Bathrooms",
      // "Vaccuum (All carpet)",
      // "Lawn and mow and lawn",
      // "Clean Window and clean"
    ];

    List<String> circle3Text = [
      "Wash Windows and Blinds",
      "Dust Baseboards and Blinds",
      "Mow lawn",
      "Babysit baby Kylie",
      // "Mop floors",
      // "Give coal to yessir",
      // "Beat the South yessir",
      // "Run run run away yessir",
    ];

    CircleData exampleCircle = CircleData(
      chartTitle: "Example Chart",
      numberOfRings: 3,
      circleOneText: circle1Text,
      circleTwoText: circle2Text,
      circleThreeText: circle3Text,
    );

    CircleData exampleCircle2 = CircleData(
      chartTitle: "Second Chart",
      numberOfRings: 2,
      circleOneText: circle1Text,
      circleTwoText: circle2Text,
      circleThreeText: [],
    );

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePageWidget();
        } else {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(Global.toolbarHeight),
              child: AppBar(
                toolbarHeight: Global.toolbarHeight,
                centerTitle: true,
                title: Text(
                  "Sign-In",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            body: const LoginWidget(),
          );
        }
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget HomePageWidget() {
    return DefaultTabController(
      length: tabsToUse.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Global.toolbarHeight),
          child: AppBar(
            toolbarHeight: Global.toolbarHeight,
            centerTitle: true,
            title: Text(
              tabsToUse.elementAt(controller.index).text as String,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        bottomNavigationBar: getBottomNavigationBar(context),
        body: TabBarView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (int i = 0; i < tabsToUse.length - 1; i++) TabContent(i),
            const SettingsContent(),
          ],
        ),
      ),
    );
  }
}
