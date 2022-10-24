import 'package:chore_app/Widgets/ConcentricChart.dart';
import 'package:flutter/material.dart';

import '../Global.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> circle1Text = [
      "Person 1",
      "Person 2",
      "Person 3",
      "Person 4",
      // "John Cina",
      // "Jamison III",
      // "Santa Claus",
      // "Abe Lincoln"
    ];

    List<String> circle2Text = [
      "Bathrooms",
      //"Clean Floors (Sweep, mop)",
      "Kitchen (dishes)",
      "Kitchen (oven, counters)",
      "Floors / windows",
      // "Don't die",
      // "Wash the fat dogs",
      // "Clean up after the baby",
      // "Give a speech"
    ];

    List<String> circle3Text = [
      "Rooms",
      "Rooms",
      "Rooms",
      "Rooms",
      // "Travel to Russia nyet",
      // "Give coal to naughty kids",
      // "Beat the South",
      // "Run",
    ];

    //In the future we'll grab any/all charts from system memory
    //or firebase (depending on updates and all that)
    //For now it's all hard-coded and we currently only
    //have one chart but in the future I'm thinking of giving the
    //user up to 3, maybe
    //Also use title of first chart as title here in the Scaffold

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
            numberOfRings: 3,
            height: MediaQuery.of(context).size.height,
            spaceBetweenLines: 15,
            shouldHaveFluidTextTransition: true,
            //Circle 1
            circleOneText: circle1Text,
            circleOneRadiusProportions: const [0.25, 0.35],
            circleOneColor:
                //Colors.transparent,
                Global.currentTheme.primaryColor,
            circleOneFontColor: Colors.black,
            circleOneFontSize: 8.0,
            circleOneTextRadiusProportion: 0.6,
            //Circle 2
            circleTwoText: circle2Text,
            circleTwoRadiusProportions: const [0.40, 0.75],
            circleTwoColor: Global.currentTheme.secondaryColor,
            circleTwoFontColor: Colors.black,
            circleThreeTextPixelOffset: 0,
            //Circle 3
            circleTwoFontSize: 14.0,
            circleThreeText: circle3Text,
            circleThreeRadiusProportions: const [0.9, 0],
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
