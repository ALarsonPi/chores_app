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
      "John Cina",
      "Jamison III",
      "Santa Claus",
      "Abe Lincoln"
    ];
    List<String> circle2Text = [
      "bop bop bop",
      "Clean Floors (Sweep, mop)",
      "Run around good sir",
      "Clean the Toilet :)",
      "Don't die",
      "Wash the fat dogs",
      "Clean up after the baby",
      "Give a speech"
    ];
    List<String> circle3Text = [
      "bop bop bop bop",
      "Clean oven with all your might mind and strength with an eye single to the glory of God",
      "Shovel Snow",
      "Grow Potatoes",
      "Travel to Russia",
      "Give coal to naughty kids",
      "Beat the South"
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
            circleOneText: circle1Text,
            circleOneColor: Global.currentTheme.primaryColor,
            circleOneFontColor: Colors.black,
            circleOneFontSize: 8.0,
            circleOneRadiusProportion: 0.6,
            circleTwoText: circle2Text,
            circleTwoColor: Global.currentTheme.secondaryColor,
            circleTwoFontColor: Colors.white,
            circleTwoFontSize: 14.0,
            circleThreeText: circle3Text,
            circleThreeColor: Global.currentTheme.tertiaryColor,
            circleThreeFontColor: Colors.white,
            circleThreeFontSize: 14.0,
          ),
        ],
      ),
    );
  }
}
