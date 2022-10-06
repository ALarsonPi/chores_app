import 'package:flutter/material.dart';
import 'RotatingPieChart/Objects/PieChartItem.dart';
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

    pieTwoItems.add(PieChartItem(1, "Raking", Colors.red));
    pieTwoItems.add(PieChartItem(1, "Mopping", Colors.red));
    pieTwoItems.add(PieChartItem(1, "Clean Oven", Colors.red));
    // pieTwoItems.add(PieChartItem(1, "Shovel Snow", Colors.red));
    // pieTwoItems.add(PieChartItem(1, "Grow Potatoes", Colors.red));
    // pieTwoItems.add(PieChartItem(1, "Travel to Russia", Colors.red));

    if (widget.numberOfRings == 2) {
      //heightOfPieTwo = 0.9;
      heightOfPieOne = 0.75;
      heightOfNameItems = 0.35;
    } else if (widget.numberOfRings == 3) {
      heightOfNameItems = 0.15;
      heightOfPieTwo = 0.9;
      heightOfPieOne = 0.30;
    } else {
      heightOfPieTwo = 0.9;
      heightOfPieOne = 0.85;
      heightOfNameItems = 0.65;
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

  makePieChart(double height, List<PieChartItem> pieItems, bool isNames) {
    return Center(
      child: SafeArea(
        child: RotatingPieChart(
          isNames: isNames,
          bounds: bounds,
          userChosenRadiusForText: 150,
          items: [
            ...pieItems,
          ],
          toText: (item, _) => TextPainter(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [],
                style: const TextStyle(color: Colors.black, fontSize: 8.0),
                text: (isNames) ? item.name : '',
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
            if (widget.numberOfRings == 3)
              makePieChart(MediaQuery.of(context).size.height * heightOfPieTwo,
                  pieTwoItems, false),
            makePieChart(MediaQuery.of(context).size.height * heightOfPieOne,
                pieOneItems, false),
            makePieChart(MediaQuery.of(context).size.height * heightOfNameItems,
                pieNamesItems, true),
          ],
        );
      },
    );
  }
}
