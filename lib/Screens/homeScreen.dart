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

class _HomeScreen extends State<HomeScreen> {
  late List<CircleData> circleDataList;
  late List<Tab> tabs;
  late List<Tab> tabsToUse;

  @override
  void initState() {
    super.initState();
    fillTitles();
    setCurrTitle(0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    int numTabs = Provider.of<TabNumberProvider>(context, listen: true).numTabs;
    List<Tab> posssibletabs = [
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
    ];
    Tab settingsTab = const Tab(text: "Settings", icon: Icon(Icons.settings));

    tabsToUse = List.empty(growable: true);
    for (int i = 0; i < numTabs; i++) {
      tabsToUse.add(posssibletabs.elementAt(i));
    }
    tabsToUse.add(settingsTab);
  }

  late String currTitle;
  List<String> titleList = List.empty(growable: true);

  fillTitles() {
    titleList.add("Example Title");
    titleList.add("Second Chart");
    titleList.add("Third List");
    titleList.add("Settings");
  }

  setCurrTitle(int index) {
    setState(() {
      currTitle = titleList.elementAt(index);
    });
  }

  Widget getBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 3,
          ),
        ],
        color: Provider.of<ThemeProvider>(context, listen: true).isDarkMode
            ? Theme.of(context).backgroundColor
            : Theme.of(context).primaryColor,
      ),
      child: TabBar(
        onTap: (index) => {
          setCurrTitle(index),
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

    int currNumRingsToUse = 3;

    double screenWidth = MediaQuery.of(context).size.width;

    CircleData exampleCircle = CircleData(
      chartTitle: "Example Chart",
      numberOfRings: currNumRingsToUse,
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
              currTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        bottomNavigationBar: getBottomNavigationBar(context),
        body: TabBarView(
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
