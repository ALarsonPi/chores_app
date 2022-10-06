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

  late double radiusOfRing2Text;
  late double radiusOfRing3Text;

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
    pieTwoItems.add(PieChartItem(1, "Shovel Snow", Colors.red));
    pieTwoItems.add(PieChartItem(1, "Grow Potatoes", Colors.red));
    pieTwoItems.add(PieChartItem(1, "Travel to Russia", Colors.red));

    if (widget.numberOfRings == 2) {
      heightOfPieOne = 0.75;
      heightOfNameItems = 0.35;
      radiusOfRing2Text = 150;
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

  makePieChart(double height, List<PieChartItem> pieItems, int ringNum) {
    return Center(
      child: SafeArea(
        child: RotatingPieChart(
          isNames: ringNum == 1,
          numRings: widget.numberOfRings,
          bounds: bounds,
          //This should be customized by number of rings
          // and also, which ring it is, and also screen size
          userChosenRadiusForText: (widget.numberOfRings == 2)
              ? radiusOfRing2Text
              : (ringNum == 2)
                  ? radiusOfRing2Text
                  : radiusOfRing3Text,
          items: [
            ...pieItems,
          ],
          toText: (item, _) => TextPainter(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [],
                style: const TextStyle(color: Colors.black, fontSize: 8.0),
                text: (ringNum == 1) ? item.name : '',
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
                  pieTwoItems, 3),
            makePieChart(MediaQuery.of(context).size.height * heightOfPieOne,
                pieOneItems, 2),
            makePieChart(MediaQuery.of(context).size.height * heightOfNameItems,
                pieNamesItems, 1),
          ],
        );
      },
    );
  }
}
