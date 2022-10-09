// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'RotatingPieChart/Objects/PieChartItem.dart';
import 'RotatingPieChart/Objects/PieInfo.dart';
import 'RotatingPieChart/RotatingPieChart.dart';

class ConcentricChart extends StatefulWidget {
  int numberOfRings;
  ConcentricChart({super.key, required this.numberOfRings});

  @override
  State<StatefulWidget> createState() {
    return _ConcentricChartState();
  }
}

class _ConcentricChartState extends State<ConcentricChart> {
  List<PieChartItem> pieNamesItems = List.empty(growable: true);
  List<PieChartItem> pieOneItems = List.empty(growable: true);
  List<PieChartItem> pieTwoItems = List.empty(growable: true);
  double heightOfNameItems = 0.15;
  double heightOfPieOne = 0.9;
  double heightOfPieTwo = 0.3;

  List<Center> rotatablePies = List.empty(growable: true);
  late PieInfo namesPie;
  late PieInfo firstPie;
  late PieInfo secondPie;

  late double radiusOfRing2Text;
  late double radiusOfRing3Text;

  final double NAMES_FONT_SIZE = 8.0;
  late double OUTER_RINGS_FONT_SIZE = widget.numberOfRings == 3 ? 14 : 22;
  //We may change this color for each pie later,
  //based on theme, but for now just black
  final Color TEXT_COLOR = Colors.black;

  @override
  void didChangeDependencies() {
    namesPie = PieInfo(
      pieHeightCoefficient:
          MediaQuery.of(context).size.height * heightOfNameItems,
      //In names circle - is a coefficient
      textRadius: 0.6,
      items: pieNamesItems,
      currRingNum: 1,
      textSize: NAMES_FONT_SIZE,
      textColor: TEXT_COLOR,
    );

    firstPie = PieInfo(
      pieHeightCoefficient: MediaQuery.of(context).size.height * heightOfPieOne,
      items: pieOneItems,
      textRadius: radiusOfRing2Text,
      currRingNum: 2,
      textSize: OUTER_RINGS_FONT_SIZE,
      textColor: TEXT_COLOR,
    );

    secondPie = PieInfo(
      pieHeightCoefficient: MediaQuery.of(context).size.height * heightOfPieTwo,
      items: pieTwoItems,
      textRadius: radiusOfRing3Text,
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

    if (widget.numberOfRings == 2) {
      heightOfPieOne = 0.75;
      heightOfNameItems = 0.35;
      radiusOfRing2Text = 150;
      radiusOfRing3Text = 0;
    } else if (widget.numberOfRings == 3) {
      heightOfNameItems = 0.25;
      heightOfPieTwo = 0.9;
      heightOfPieOne = 0.4;

      radiusOfRing2Text = 110;
      radiusOfRing3Text = 165;
    }

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
