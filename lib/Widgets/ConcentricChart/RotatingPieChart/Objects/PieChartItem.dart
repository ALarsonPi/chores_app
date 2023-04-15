import 'package:flutter/material.dart';

class PieChartItem {
  final Key key;
  final num val;
  final String name;
  final Color color;
  final int position;

  @override
  String toString() {
    String stringToReturn = "Pie Chart Item\n";
    stringToReturn += "===============";
    stringToReturn += "Value: $val\n";
    stringToReturn += "Name: $name\n";
    stringToReturn += "Color: $color\n";
    return stringToReturn;
  }

  PieChartItem({
    this.val = 1,
    this.name = "defaultName",
    this.color = Colors.black,
    this.key = const ValueKey("Default"),
    this.position = 0,
  }) : assert(val != 0);
}

// ignore: prefer_generic_function_type_aliases
typedef TextPainter PieChartItemToText(PieChartItem item, double total);
