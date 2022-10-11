// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import '../Global.dart';
import 'RotatingPieChart/Objects/PieChartItem.dart';
import 'RotatingPieChart/Objects/PieInfo.dart';
import 'RotatingPieChart/RotatingPieChart.dart';

class ConcentricChart extends StatefulWidget {
  int numberOfRings;
  late final double namesFontSize;
  late final double outerRingsFontSize;
  late final Color fontColor;
  ConcentricChart({super.key, required this.numberOfRings}) {
    namesFontSize = 8.0;
    double pixelRatioCoefficient = (Global.isHighPixelRatio) ? 0.0 : 0.05;
    double textFontCoefficient =
        ((Global.isPhone) ? 1.0 : 2.0) + pixelRatioCoefficient;
    outerRingsFontSize =
        ((numberOfRings == 3) ? 14.0 : 18.0) * textFontCoefficient;
    fontColor = Colors.black;
  }

  @override
  State<StatefulWidget> createState() {
    return _ConcentricChartState();
  }
}

class _ConcentricChartState extends State<ConcentricChart> {
  List<PieChartItem> pieNamesItems = List.empty(growable: true);
  List<PieChartItem> pieOneItems = List.empty(growable: true);
  List<PieChartItem> pieTwoItems = List.empty(growable: true);

  List<Center> rotatablePies = List.empty(growable: true);
  late PieInfo namesPie;
  late PieInfo firstPie;
  late PieInfo secondPie;

  // ignore: non_constant_identifier_names
  late double NAMES_FONT_SIZE;
  // ignore: non_constant_identifier_names
  late double OUTER_RINGS_FONT_SIZE;
  // ignore: non_constant_identifier_names
  late Color TEXT_COLOR;

  @override
  void didChangeDependencies() {
    NAMES_FONT_SIZE = widget.namesFontSize;
    OUTER_RINGS_FONT_SIZE = widget.outerRingsFontSize;
    TEXT_COLOR = widget.fontColor;

    double nameProportion = 0.0;
    double pie1Proportion = 0.0;
    double pie2Proportion = 0.0;

    double ring2TextRadius = 0.0;
    double ring3TextRadius = 0.0;

    if (widget.numberOfRings == 2) {
      nameProportion = 0.35;
      if (!Global.isPhone) nameProportion += 0.1;
      if (Global.isHighPixelRatio) nameProportion -= 0.08;

      pie1Proportion = 0.75;
      pie2Proportion = 0.00;

      ring2TextRadius = (MediaQuery.of(context).size.height * 0.45) / 2.0;
      if (Global.isHighPixelRatio) ring2TextRadius -= 45;
      if (!Global.isPhone) ring2TextRadius += 75;
      ring3TextRadius = 0.0;
    } else if (widget.numberOfRings == 3) {
      nameProportion = 0.25;

      if (!Global.isPhone) nameProportion += 0.06;
      if (Global.isHighPixelRatio) nameProportion -= 0.06;

      pie1Proportion = 0.4;
      if (!Global.isPhone) pie1Proportion += 0.14;
      if (Global.isHighPixelRatio) pie1Proportion -= 0.08;

      pie2Proportion = 0.9;

      ring2TextRadius =
          (MediaQuery.of(context).size.height * pie1Proportion) / 2.4;
      if (!Global.isPhone) ring2TextRadius += 5;

      ring3TextRadius =
          (MediaQuery.of(context).size.height * pie1Proportion) / 1.65;

      if (!Global.isPhone) ring3TextRadius += 5;
      if (MediaQuery.of(context).devicePixelRatio > 2) ring3TextRadius += 5.0;
    }

    namesPie = PieInfo(
      pieHeightCoefficient: MediaQuery.of(context).size.height * nameProportion,
      //In names circle - is a coefficient
      textRadius: 0.6,
      items: pieNamesItems,
      currRingNum: 1,
      textSize: NAMES_FONT_SIZE,
      textColor: TEXT_COLOR,
    );

    firstPie = PieInfo(
      pieHeightCoefficient: MediaQuery.of(context).size.height * pie1Proportion,
      items: pieOneItems,
      textRadius: ring2TextRadius,
      currRingNum: 2,
      textSize: OUTER_RINGS_FONT_SIZE,
      textColor: TEXT_COLOR,
    );

    secondPie = PieInfo(
      pieHeightCoefficient: MediaQuery.of(context).size.height * pie2Proportion,
      items: pieTwoItems,
      textRadius: ring3TextRadius,
      currRingNum: 3,
      textSize: OUTER_RINGS_FONT_SIZE,
      textColor: TEXT_COLOR,
    );

    if (widget.numberOfRings == 3) {
      rotatablePies.add(makePieChart(secondPie));
    }
    rotatablePies.add(makePieChart(firstPie));
    rotatablePies.add(makePieChart(namesPie));

    super.didChangeDependencies();
  }

  @override
  void initState() {
    //THESE CHARTS SHOULD HAVE A MAX OF 8 ITEMS
    //AND A MINIMUM OF 3 ITEMS

    pieNamesItems.add(PieChartItem(1, "Jacob", Colors.yellow));
    pieNamesItems.add(PieChartItem(1, "Jonathan", Colors.yellow));
    pieNamesItems.add(PieChartItem(1, "James", Colors.yellow));
    pieNamesItems.add(PieChartItem(1, "Adopted\nHobo", Colors.yellow));
    pieNamesItems.add(PieChartItem(1, "John\nCina", Colors.yellow));
    pieNamesItems.add(PieChartItem(1, "Jamison\nIII", Colors.yellow));
    // pieNamesItems.add(PieChartItem(1, "Santa\nClaus", Colors.yellow));
    // pieNamesItems.add(PieChartItem(1, "Abe\nLincoln", Colors.yellow));

    pieOneItems.add(PieChartItem(1, "Wash the dogs", Colors.orange));
    pieOneItems.add(PieChartItem(1, "Floorsssssssss", Colors.orange));
    pieOneItems.add(PieChartItem(1, "Run around good sir", Colors.orange));
    pieOneItems.add(PieChartItem(1, "Clean the Toilet :)", Colors.orange));
    pieOneItems.add(PieChartItem(1, "Don't die", Colors.orange));
    pieOneItems.add(PieChartItem(1, "Wash the fat dogs", Colors.orange));
    // pieOneItems
    //     .add(PieChartItem(1, "Clean up after the reindeer", Colors.orange));
    // pieOneItems.add(PieChartItem(1, "Give a speech", Colors.orange));

    pieTwoItems.add(
        PieChartItem(1, "Raking leavvvvvvvvvvvvvvvvvvvvvvvves", Colors.red));
    pieTwoItems.add(PieChartItem(1, "Mopping", Colors.red));
    pieTwoItems.add(PieChartItem(1, "Clean Oven", Colors.red));
    pieTwoItems.add(PieChartItem(1, "Shovel Snow", Colors.red));
    pieTwoItems.add(PieChartItem(1, "Grow Potatoes", Colors.red));
    pieTwoItems.add(PieChartItem(1, "Travel to Russia", Colors.red));
    // pieTwoItems.add(PieChartItem(1, "Give coal to naughty kids", Colors.red));
    // pieTwoItems.add(PieChartItem(1, "Beat the South", Colors.red));

    populateBounds(pieNamesItems.length);

    //In terms of getting a formula for how many letters can be input for a
    // certain chart - it will require 3 things
    // 1. Num Items (primarily)
    // 2. Type of device (tablet/phone)
    // 3. Pixel/Aspect Ratio
    // 4. And will probably need a safe zone (and I'll err on the safe side)
    // Might end up making it something that I calculate ahead of time for a
    // base value and then using the device type and aspect ratio to
    // tweak it slightly

    super.initState();
  }

  List<double> bounds = List.empty(growable: true);
  populateBounds(int numItems) {
    for (int i = 0; i <= numItems; i++) {
      bounds.add(i / numItems);
    }
  }

  makePieChart(PieInfo pie) {
    return Center(
      child: SafeArea(
        child: RotatingPieChart(
          bounds: bounds,
          pie: pie,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Stack(
          children: [
            ...rotatablePies,
          ],
        );
      },
    );
  }
}
