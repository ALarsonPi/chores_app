import 'package:chore_app/Widgets/ConcentricChart.dart';
import 'package:flutter/material.dart';

import '../Global.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> circle1Text = [
      "Jacob",
      "Jonathan",
      "James",
      "Adopted Hobo",
      // "John Cina",
      // "Jamison III",
      // "Santa Claus",
      // "Abe Lincoln"
    ];
    List<String> circle2Text = [
      "bop bop bop",
      "Clean Floors (Sweep, mop), but also remember to wipe the baseboards",
      "Run around good sir",
      "Clean the Bathroom",
      // "Don't die",
      //"Wash the fat dogs",
      // "Clean up after the baby",
      // "Give a speech"
    ];
    List<String> circle3Text = [
      "bop",
      // "Clean oven with all your might mind and strength with an eye single to the glory of God",
      "Shovel Snow",
      "Grow Potatoes",
      "Travel to Russia nyet good sir hy ya dum doo doo",
      // "Give coal to naughty kids",
      // "Beat the South"
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
            //Circle 1
            circleOneText: circle1Text,
            circleOneRadiusProportions: const [0.25, 0.35],
            circleOneColor: Global.currentTheme.primaryColor,
            circleOneFontColor: Colors.black,
            circleOneFontSize: 8.0,
            circleOneTextRadiusProportion: 0.6,
            //Circle 2
            circleTwoText: circle2Text,
            circleTwoRadiusProportions: const [0.40, 0.75],
            circleTwoColor: Global.currentTheme.secondaryColor,
            circleTwoFontColor: Colors.white,
            circleThreeTextPixelOffset: 0,
            //Circle 3
            circleTwoFontSize: 14.0,
            circleThreeText: circle3Text,
            circleThreeRadiusProportions: const [0.9, 0],
            circleThreeColor: Global.currentTheme.tertiaryColor,
            circleThreeFontColor: Colors.white,
            circleThreeFontSize: 14.0,
            circleTwoTextPixelOffset: 0,
          ),
        ],
      ),
    );
  }
}
