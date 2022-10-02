import 'package:flutter/material.dart';

class PieChartItem {
  final num val;
  final String name;
  final Color color;

  @override
  String toString() {
    String stringToReturn = "Pie Chart Item\n";
    stringToReturn += "===============";
    stringToReturn += "Value: $val\n";
    stringToReturn += "Name: $name\n";
    stringToReturn += "Color: $color\n";
    return stringToReturn;
  }

  PieChartItem(this.val, this.name, this.color) : assert(val != 0);
}

typedef TextPainter PieChartItemToText(PieChartItem item, double total);
