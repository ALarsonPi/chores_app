import 'package:chore_app/Models/CircleData.dart';
import 'package:chore_app/Widgets/ConcentricChart.dart';
import 'package:chore_app/Widgets/SettingsTab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Global.dart';
import '../Providers/ThemeProvider.dart';

/// @nodoc
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
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
        tabs: const [
          Tab(
            text: "Chart 1",
            icon: Icon(Icons.looks_one),
          ),
          Tab(
            text: "Chart 2",
            icon: Icon(Icons.looks_two),
          ),
          Tab(
            text: "Chart 3",
            icon: Icon(Icons.looks_3),
          ),
          Tab(
            text: "Settings",
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fillTitles();
    setCurrTitle(0);
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

  Widget getCircleChart(CircleData currCircleData, double screenWidth) {
    return Stack(
      children: [
        ConcentricChart(
          // Specific To each Circle
          numberOfRings: currCircleData.numberOfRings,
          circleOneText: currCircleData.circleOneText,
          circleTwoText: currCircleData.circleTwoText,
          circleThreeText: currCircleData.circleThreeText,

          // Theme
          linesColors: Global.currentTheme.lineColors,
          circleOneColor: Global.currentTheme.primaryColor,
          circleOneFontColor: Global.currentTheme.primaryTextColor,
          circleTwoColor: Global.currentTheme.secondaryColor,
          circleTwoFontColor: Global.currentTheme.secondaryTextColor,
          circleThreeColor: Global.currentTheme.tertiaryColor,
          circleThreeFontColor: Global.currentTheme.tertiaryTextColor,

          // Const Programmer Decisions
          width: screenWidth,
          spaceBetweenLines: Global.circleSettings.spaceBetweenLines,
          overflowLineLimit: Global.circleSettings.overflowLineLimit,
          chunkOverflowLimitProportion:
              Global.circleSettings.chunkOverflowLimitProportion,
          circleOneRadiusProportions:
              Global.circleSettings.circleOneRadiusProportions,
          circleOneFontSize: Global.circleSettings.circleOneFontSize,
          circleOneTextRadiusProportion:
              Global.circleSettings.circleOneTextRadiusProportion,
          circleTwoRadiusProportions:
              Global.circleSettings.circleTwoRadiusProportions,
          circleTwoFontSize: Global.circleSettings.circleTwoFontSize,
          circleThreeRadiusProportion:
              Global.circleSettings.circleThreeRadiusProportion,
          circleThreeFontSize: Global.circleSettings.circleThreeFontSize,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> circle1Text = [
      "John",
      "Jamie",
      "Will",
      "Abby",
      // "Johnny",
      // "Jake",
      // "Santa",
      // "Abe"
    ];

    List<String> circle2Text = [
      "Will you go",
      "Sweep/Mop go to",
      "Pots/Pans go to",
      "Windows and window",
      // "Mop and sweep and mop",
      // "Sweep and mop and sweep",
      // "Lawn and mow and lawn",
      // "Clean Window and clean"
    ];

    List<String> circle3Text = [
      "Windows and window and also",
      "Mop + sweep and go",
      "Mow lawn each week",
      "Babysit and go to the place",
      // "Travel to Russia my boi",
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
      length: 4,
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
            getCircleChart(exampleCircle, screenWidth),
            getCircleChart(exampleCircle2, screenWidth),
            getCircleChart(exampleCircle, screenWidth),
            const SettingsTab(),
          ],
        ),
      ),
    );
  }
}
