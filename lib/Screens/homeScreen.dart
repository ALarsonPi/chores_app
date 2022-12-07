import 'package:chore_app/Models/CircleData.dart';
import 'package:chore_app/Providers/CircleDataProvider.dart';
import 'package:chore_app/Providers/TabNumberProvider.dart';
import 'package:chore_app/Widgets/ConcentricChart/ConcentricChart.dart';
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
  late List<Tab> tabs = [
    const Tab(
      text: "Chart 1",
      icon: Icon(Icons.looks_one),
    ),
    const Tab(
      text: "Chart 2",
      icon: Icon(Icons.looks_two),
    ),
    const Tab(
      text: "Chart 3",
      icon: Icon(Icons.looks_3),
    ),
    const Tab(
      text: "Settings",
      icon: Icon(Icons.settings),
    ),
  ];
  late List<Tab> tabsToUse;
  late TabController controller;

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

    int numTabs = Provider.of<TabNumberProvider>(context, listen: true).numTabs;
    controller = TabController(length: numTabs + 1, vsync: this);

    tabsToUse = List.empty(growable: true);
    for (int i = 0; i < numTabs; i++) {
      tabsToUse.add(tabs.elementAt(i));
    }
    // Settings Tab
    tabsToUse.add(tabs.last);
    setControllerToFinalTab();
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
