import 'package:flutter/material.dart';
import '../RotatingPieChart/PieChartItem.dart';
import '../RotatingPieChart/RotatingPieChart.dart';

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
  double heightOfNameItems = 0.0;
  double heightOfPieOne = 0.0;
  double heightOfPieTwo = 0.0;

  @override
  void initState() {
    pieNamesItems.add(PieChartItem(1, "Susan", Colors.yellow));
    pieNamesItems.add(PieChartItem(1, "Dad", Colors.yellow));
    pieNamesItems.add(PieChartItem(1, "Mom", Colors.yellow));

    pieOneItems.add(PieChartItem(1, "Bathroom", Colors.orange));
    pieOneItems.add(PieChartItem(1, "Floors", Colors.orange));
    pieOneItems.add(PieChartItem(1, "Dishes", Colors.orange));

    pieTwoItems.add(PieChartItem(1, "Raking", Colors.red));
    pieTwoItems.add(PieChartItem(1, "Mopping", Colors.red));
    pieTwoItems.add(PieChartItem(1, "Clean Oven", Colors.red));

    if (widget.numberOfRings == 1) {
      //heightOfPieTwo = 0.9;
      heightOfPieOne = 0.75;
      heightOfNameItems = 0.35;
    } else if (widget.numberOfRings == 2) {
      heightOfPieTwo = 0.9;
      heightOfPieOne = 0.30;
      heightOfNameItems = 0.15;
    } else {
      heightOfPieTwo = 0.9;
      heightOfPieOne = 0.85;
      heightOfNameItems = 0.65;
    }

    super.initState();
  }

  makePieChart(double height, List<PieChartItem> pieItems) {
    return Center(
      child: SafeArea(
        child: RotatingPieChart(
          items: [
            ...pieItems,
          ],
          toText: (item, _) => TextPainter(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 8.0),
                text: "${item.name}\n${item.val}",
              ),
              textDirection: TextDirection.ltr),
          sizeOfChart: height,
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
            if (widget.numberOfRings >= 2)
              makePieChart(MediaQuery.of(context).size.height * heightOfPieTwo,
                  pieTwoItems),
            makePieChart(MediaQuery.of(context).size.height * heightOfPieOne,
                pieOneItems),
            makePieChart(MediaQuery.of(context).size.height * heightOfNameItems,
                pieNamesItems),
          ],
        );
      },
    );
  }
}