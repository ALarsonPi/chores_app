import 'package:chore_app/ColorControl/AppColors.dart';
import 'package:chore_app/Providers/ChartProvider.dart';
import 'package:chore_app/Screens/createChartScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Global.dart';
import '../Models/frozen/Chart.dart';
import '../Screens/ScreenArguments/newChartArguments.dart';
import 'ConcentricChart/ConcentricChart.dart';

class TabContent extends StatelessWidget {
  TabContent(this.circleDataIndex, {super.key});
  int circleDataIndex;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Chart currCircleData = Provider.of<ChartProvider>(context, listen: true)
        .circleDataList[circleDataIndex];
    if (!currCircleData.isEmpty()) {
      return ConcentricChart(
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
      );
    } else {
      return Stack(
        alignment: Alignment.center,
        children: [
          getGradientCircle(context),
          Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Press button below to \ncreate new chore chart!",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => {
                      Navigator.pushNamed(context, CreateChartScreen.routeName,
                          arguments: CreateChartArguments(circleDataIndex)),
                    },
                    child: Text(
                      "Create New",
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium?.fontSize,
                        color:
                            Theme.of(context).textTheme.headlineMedium?.color,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget getGradientCircle(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
      decoration: BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(Theme.of(context).primaryColor.value),
            AppColors.getPrimaryColorSwatch().shade200,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.25, 0.90],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF101012),
            offset: Offset(-8, 8),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}
