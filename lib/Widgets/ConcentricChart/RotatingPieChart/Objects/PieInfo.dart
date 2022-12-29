import 'package:flutter/material.dart';
import 'PieChartItem.dart';

class PieInfo {
  double width;
  double textProportion;
  List<PieChartItem> items;
  int ringNum;
  Color linesColor;
  bool isBold;

  late List<double> ringBorders;
  late TextStyle textStyle;

  //Could I just send in one number, and have the pieCoefficient be a certain
  //amount more?
  PieInfo({
    required this.width,
    required this.items,
    required this.ringNum,
    required this.linesColor,
    required textSize,
    required textColor,
    this.ringBorders = const [0.0, 0.0],
    this.textProportion = 0.0,
    this.isBold = false,
  }) {
    textStyle = TextStyle(
      fontSize: textSize,
      color: textColor,
      fontWeight: (isBold) ? FontWeight.bold : FontWeight.normal,
    );
  }

  @override
  String toString() {
    String stringSum =
        // ignore: prefer_interpolation_to_compose_strings
        "Pie Circle Info\nPie Width: "
        "${width}\nStarting radius of text"
        "${textProportion}\nText and angles in the chart: "
        "${items}";
    return super.toString();
  }
}
