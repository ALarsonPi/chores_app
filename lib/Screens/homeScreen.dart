import 'package:chore_app/Models/CircleData.dart';
import 'package:chore_app/Widgets/ConcentricChart.dart';
import 'package:flutter/material.dart';

import '../Global.dart';

/// @nodoc
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

    CircleData exampleCircle = CircleData(
        chartTitle: "Example Chart",
        numberOfRings: currNumRingsToUse,
        circleOneText: circle1Text,
        circleTwoText: circle2Text,
        circleThreeText: circle3Text);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Global.toolbarHeight),
        child: AppBar(
          toolbarHeight: Global.toolbarHeight,
          centerTitle: true,
          title: Text(
            exampleCircle.chartTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
      body: Stack(
        children: [
          ConcentricChart(
            // Specific To each Circle
            numberOfRings: exampleCircle.numberOfRings,
            circleOneText: exampleCircle.circleOneText,
            circleTwoText: exampleCircle.circleTwoText,
            circleThreeText: exampleCircle.circleThreeText,

            // Theme
            linesColors: Global.currentTheme.lineColors,
            circleOneColor: Global.currentTheme.primaryColor,
            circleOneFontColor: Global.currentTheme.primaryTextColor,
            circleTwoColor: Global.currentTheme.secondaryColor,
            circleTwoFontColor: Global.currentTheme.secondaryTextColor,
            circleThreeColor: Global.currentTheme.tertiaryColor,
            circleThreeFontColor: Global.currentTheme.tertiaryTextColor,

            // Const Programmer Decisions
            width: MediaQuery.of(context).size.width,
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
      ),
    );
  }
}
