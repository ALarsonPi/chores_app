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
    outerRingsFontSize = (numberOfRings == 3) ? 14.0 : 22.0;
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

    double nameProportion = (widget.numberOfRings == 2) ? 0.35 : 0.25;
    double pie1Proportion = (widget.numberOfRings == 2) ? 0.75 : 0.4;
    double pie2Proportion = (widget.numberOfRings == 2) ? 0.00 : 0.9;

    double ring2TextRadius = (widget.numberOfRings == 2) ? 150.0 : 110.0;
    double ring3TextRadius = (widget.numberOfRings == 2) ? 0.0 : 165.0;

    //Here's my idea for how to get the sizing to work on multiple / all platforms
    // 1. Have a variable size based on screenwidth? or height and the pixel ratio
    // 2. Have a max (cap) size for phones and for tablets/computers that it will
    //       use if the adaptive size gets too big

    debugPrint(MediaQuery.of(context).devicePixelRatio.toString());
    namesPie = PieInfo(
      pieHeightCoefficient: MediaQuery.of(context).size.height * nameProportion
      // * MediaQuery.of(context).devicePixelRatio,
      ,
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
    pieNamesItems.add(PieChartItem(1, "Jacob", Colors.yellow));
    pieNamesItems.add(PieChartItem(1, "Jonathan", Colors.yellow));
    pieNamesItems.add(PieChartItem(1, "James", Colors.yellow));
    pieNamesItems.add(PieChartItem(1, "Adopted\nHobo", Colors.yellow));
    pieNamesItems.add(PieChartItem(1, "John\nCina", Colors.yellow));
    pieNamesItems.add(PieChartItem(1, "Jamison III", Colors.yellow));

    pieOneItems.add(PieChartItem(1, "Wash the dogs", Colors.orange));
    pieOneItems.add(PieChartItem(1, "Clean the blinds", Colors.orange));
    pieOneItems.add(PieChartItem(1, "Run around good sir", Colors.orange));
    pieOneItems.add(PieChartItem(1, "Clean the Toilet :)", Colors.orange));
    pieOneItems.add(PieChartItem(1, "Don't die", Colors.orange));
    pieOneItems.add(PieChartItem(1, "Wash the fat dogs", Colors.orange));

    // pieOneItems.add(PieChartItem(1, "Make a smoothie", Colors.orange));

    pieTwoItems.add(
        PieChartItem(1, "Raking leavvvvvvvvvvvvvvvvvvvvvvvves", Colors.red));
    pieTwoItems.add(PieChartItem(1, "Mopping", Colors.red));
    pieTwoItems.add(PieChartItem(1, "Clean Oven", Colors.red));
    pieTwoItems.add(PieChartItem(1, "Shovel Snow", Colors.red));
    pieTwoItems.add(PieChartItem(1, "Grow Potatoes", Colors.red));
    pieTwoItems.add(PieChartItem(1, "Travel to Russia", Colors.red));

    populateBounds(pieNamesItems.length);

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
