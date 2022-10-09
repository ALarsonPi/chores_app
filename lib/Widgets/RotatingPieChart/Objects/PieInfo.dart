import 'package:flutter/material.dart';
import 'PieChartItem.dart';

class PieInfo {
  late double heightCoefficient;
  late double startingRadiusOfText;
  late List<PieChartItem> textAndAngleItems;
  late int ringNum;
  late TextStyle textStyle;

  //Could I just send in one number, and have the pieCoefficient be a certain
  //amount more?
  PieInfo({
    required pieHeightCoefficient,
    required items,
    required textRadius,
    required currRingNum,
    required textSize,
    required textColor,
  }) {
    heightCoefficient = pieHeightCoefficient;
    startingRadiusOfText = textRadius;
    textAndAngleItems = items;
    ringNum = currRingNum;
    textStyle = TextStyle(
      fontSize: textSize,
      color: textColor,
    );
  }

  @override
  String toString() {
    String stringSum =
        // ignore: prefer_interpolation_to_compose_strings
        "Pie Circle Info\nPie Width Multiplier: "
        "${heightCoefficient}\nStarting radius of text"
        "${startingRadiusOfText}\nText and angles in the chart: "
        "${textAndAngleItems}";
    return super.toString();
  }
}
