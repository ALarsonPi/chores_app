import 'package:chore_app/Providers/CircleDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Global.dart';
import '../Models/CircleData.dart';
import '../Providers/TabNumberProvider.dart';
import 'ConcentricChart/ConcentricChart.dart';

class TabContent extends StatelessWidget {
  TabContent(this.circleDataIndex);
  int circleDataIndex;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    CircleData currCircleData =
        Provider.of<CircleDataProvider>(context, listen: false)
            .circleDataList[circleDataIndex];
    if (currCircleData.isEmpty()) {
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
    } else {
      return Text("EMPTY");
    }
  }
}
