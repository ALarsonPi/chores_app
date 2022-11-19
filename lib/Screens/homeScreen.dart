import 'package:chore_app/Widgets/ConcentricChart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

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
      "Johnny",
      "Jake",
      "Santa",
      "Abe"
    ];

    List<String> circle2Text = [
      "Sweep/Mop",
      "Sweep/Mop",
      "Pots/Pans",
      "Windows",
      "Mop",
      "Sweep",
      "Lawn",
      "Clean Window"
    ];

    List<String> circle3Text = [
      "Vacuum",
      "Mop + sweep patio",
      "Mow lawn each week",
      "Babysit little Jessica",
      "Travel to Russia",
      "Give coal to kids",
      "Beat the South",
      "Run",
    ];

    //In the future we'll grab any/all charts from system memory
    //or firebase (depending on updates and all that)
    //For now it's all hard-coded and we currently only
    //have one chart but in the future I'm thinking of giving the
    //user up to 3, maybe
    //Also use title of first chart as title here in the Scaffold

    int currNumRingsToUse = 3;

    List<double> circle1Proportions = [];
    List<double> circle2Proportions = [];
    List<double> circle2TextProportions = [];
    double circle3Proportion = 1.0;
    double circle3TextProportion = 0.4;

    if (MediaQuery.of(context).size.width < 350 || Global.isPhone) {
      circle1Proportions = [0.4, 0.6];
      circle2Proportions = [0.7, 1.0];
      circle3Proportion = 1.0;

      circle2TextProportions = [0.25, 0.4];
      circle3TextProportion = 0.4;

      if (Global.isHighPixelRatio && Device.get().isAndroid) {
        circle1Proportions = [0.35, 0.6];
        circle2Proportions = [0.575, 1.0];
        circle2TextProportions = [0.17, 0.4];
        circle3TextProportion = 0.28;
      }
    } else {
      circle1Proportions = [0.35, 0.5];
      circle2Proportions = [0.6, 1.0];
      circle3Proportion = 1.0;

      circle2TextProportions = [0.25, 0.35];
      circle3TextProportion = 0.4;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Global.toolbarHeight),
        child: AppBar(
          toolbarHeight: Global.toolbarHeight,
          centerTitle: true,
          title: Text(
            "Chart 1",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
      body: Stack(
        children: [
          ConcentricChart(
            // Gen Info
            numberOfRings: currNumRingsToUse,
            width: MediaQuery.of(context).size.width,
            spaceBetweenLines: 15,
            linesColors: const [Colors.blue, Colors.white, Colors.white],
            // Settings
            shouldFlipText: true,
            shouldTextCenterVertically: true,
            shouldHaveFluidTextTransition: true,
            overflowLineLimit: 2,
            chunkOverflowLimitProportion: 0.15,
            // Circle 1
            circleOneText: circle1Text,
            circleOneRadiusProportions: circle1Proportions,
            circleOneColor: //Colors.transparent,
                Global.currentTheme.primaryColor,
            circleOneFontColor: Colors.black,
            circleOneFontSize: 8.0,
            circleOneTextRadiusProportion: 0.6,
            // Circle 2
            circleTwoText: circle2Text,
            circleTwoRadiusProportions: circle2Proportions,
            circleTwoTextProportions: circle2TextProportions,
            circleTwoColor: Global.currentTheme.secondaryColor,
            circleTwoFontColor: Colors.black,
            circleThreeTextPixelOffset: 0,
            circleTwoFontSize: 14.0,
            // Circle 3
            circleThreeText: circle3Text,
            circleThreeRadiusProportion: circle3Proportion,
            circleThreeTextProportion: circle3TextProportion,
            circleThreeColor: Global.currentTheme.tertiaryColor,
            circleThreeFontColor: Colors.black,
            circleThreeFontSize: 14.0,
            circleTwoTextPixelOffset: 0,
          ),
        ],
      ),
    );
  }
}
