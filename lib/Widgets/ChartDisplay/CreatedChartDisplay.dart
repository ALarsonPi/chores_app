import 'package:chore_app/Providers/TextSizeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Global.dart';
import '../../Models/frozen/Chart.dart';
import '../ConcentricChart/ConcentricChart.dart';

class CreatedChartDisplay extends StatelessWidget {
  CreatedChartDisplay(this.currTabIndex, this.currChart, {super.key});
  int currTabIndex;
  Chart currChart;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.075,
              right: MediaQuery.of(context).size.width * 0.075,
            ),
            child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow,
                    Colors.orangeAccent,
                    Colors.yellow.shade300,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Card(
                color: Colors.white,
                child: Center(
                  child: Text(
                    currChart.id.substring(0, 8),
                    style: TextStyle(
                      fontSize: (Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.fontSize as double) +
                          Provider.of<TextSizeProvider>(context, listen: false)
                              .fontSizeToAdd,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
        ConcentricChart(
          // Specific To each Circle
          numberOfRings: currChart.numberOfRings,
          circleOneText: currChart.circleOneText,
          circleTwoText: currChart.circleTwoText,
          circleThreeText: currChart.circleThreeText ?? [],
          shouldBold: true,

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
          circleOneFontSize: Global.circleSettings.circleOneFontSize +
              Provider.of<TextSizeProvider>(context, listen: false)
                  .fontSizeToAdd,
          circleOneTextRadiusProportion:
              Global.circleSettings.circleOneTextRadiusProportion,
          circleTwoRadiusProportions:
              Global.circleSettings.circleTwoRadiusProportions,
          circleTwoFontSize: Global.circleSettings.circleTwoFontSize +
              Provider.of<TextSizeProvider>(context, listen: false)
                  .fontSizeToAdd,
          circleThreeRadiusProportion:
              Global.circleSettings.circleThreeRadiusProportion,
          circleThreeFontSize: Global.circleSettings.circleThreeFontSize +
              Provider.of<TextSizeProvider>(context, listen: false)
                  .fontSizeToAdd,
        ),
      ],
    );
  }
}
