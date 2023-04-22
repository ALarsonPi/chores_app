import 'package:chore_app/Providers/TextSizeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Daos/ChartDao.dart';
import '../../Global.dart';
import '../../Models/frozen/Chart.dart';
import '../../Models/frozen/UserModel.dart';
import '../ConcentricChart/ConcentricChart.dart';

// ignore: must_be_immutable
class CreatedChartDisplay extends StatelessWidget {
  CreatedChartDisplay(this.currTabIndex, this.currChart, {super.key});
  int currTabIndex;
  Chart currChart;

  notifyOfChartUpdate(int ringNum, List<String> values) {
    debugPrint("Update occurred");
  }

  @override
  Widget build(BuildContext context) {
    List<UserModel> currUserList =
        Provider.of<List<UserModel>>(context, listen: true);
    if (currUserList.isEmpty) {
      return const SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(),
      );
    }
    UserModel currUser = currUserList.first;

    double screenWidth = MediaQuery.of(context).size.width;
    String currUserId = currUser.id;
    bool isStillPending = currChart.pendingIDs.contains(currUserId);
    bool isOnlyViewer = currChart.viewerIDs.contains(currUserId);
    ChartDao chartDao = ChartDao();
    return Stack(
      children: [
        ElevatedButton(
          onPressed: () => {
            chartDao.updateChartAngle(0, 3.1415, "0WKUXU4PW5662l2i2Tsd"),
          },
          child: const Text("Update angle of circle"),
        ),
        if (isStillPending)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Text(
                    "Waiting for owners of chart to \napprove your request to join",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: (Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.fontSize as double) +
                          Provider.of<TextSizeProvider>(context, listen: false)
                              .fontSizeToAdd,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.75,
                  height: screenWidth * 0.75,
                  child: Image.network(
                      "https://cdn-icons-png.flaticon.com/512/3759/3759237.png"),
                ),
              ],
            ),
          ),
        if (isOnlyViewer)
          Positioned(
            top: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.075,
                left: MediaQuery.of(context).size.width * 0.075,
              ),
              child: SizedBox(
                height: 50,
                width: 150,
                child: Center(
                  child: Text(
                    "VIEW ONLY",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: (Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.fontSize as double) +
                          Provider.of<TextSizeProvider>(context, listen: false)
                              .fontSizeToAdd,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (!isStillPending)
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
                            Provider.of<TextSizeProvider>(context,
                                    listen: false)
                                .fontSizeToAdd,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (!isStillPending)
          ConcentricChart(
            // Specific To each Circle
            onChanged: notifyOfChartUpdate,
            numberOfRings: currChart.numberOfRings,
            circleOneText: currChart.circleOneText,
            circleTwoText: currChart.circleTwoText,
            circleThreeText: currChart.circleThreeText ?? [],
            shouldBold: true,
            shouldIgnoreTouch: isOnlyViewer,
            currRingOneAngle: currChart.circleOneAngle,
            currRingTwoAngle: currChart.circleTwoAngle,
            currRingThreeAngle: currChart.circleThreeAngle,

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
