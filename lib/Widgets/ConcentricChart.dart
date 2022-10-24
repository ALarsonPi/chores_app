import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'RotatingPieChart/Objects/PieChartItem.dart';
import 'RotatingPieChart/Objects/PieInfo.dart';
import 'RotatingPieChart/RotatingPieChart.dart';

class ConcentricChart extends StatefulWidget {
  int numberOfRings;
  double height;
  double spaceBetweenLines;

  List<String> circleOneText;
  Color circleOneColor;
  Color circleOneFontColor;
  double circleOneFontSize;
  double circleOneTextRadiusProportion;
  List<double> circleOneRadiusProportions;

  List<String> circleTwoText;
  Color circleTwoColor;
  Color circleTwoFontColor;
  double circleTwoFontSize;
  List<double> circleTwoRadiusProportions;
  double circleTwoTextPixelOffset;

  List<String> circleThreeText;
  Color circleThreeColor;
  Color circleThreeFontColor;
  double circleThreeFontSize;
  List<double> circleThreeRadiusProportions;
  double circleThreeTextPixelOffset;

  bool shouldHaveFluidTextTransition;
  int overflowLineLimit;

  ConcentricChart({
    super.key,
    required this.numberOfRings,
    required this.circleOneText,
    required this.circleOneColor,
    required this.circleTwoText,
    required this.circleTwoColor,
    required this.circleThreeText,
    required this.circleThreeColor,
    required this.circleOneFontColor,
    required this.circleTwoFontColor,
    required this.circleThreeFontColor,
    this.height = 1080,
    this.circleOneTextRadiusProportion = 0.6,
    this.circleOneFontSize = 8.0,
    this.circleTwoFontSize = 14.0,
    this.circleThreeFontSize = 14.0,
    this.circleOneRadiusProportions = const [0.25, 0.35],
    this.circleTwoRadiusProportions = const [0.4, 0.75],
    this.circleThreeRadiusProportions = const [0.9, 0],
    this.circleTwoTextPixelOffset = 0.0,
    this.circleThreeTextPixelOffset = 0.0,
    this.spaceBetweenLines = 20,
    this.shouldHaveFluidTextTransition = true,
    this.overflowLineLimit = 2,
  }) {
    double pixelRatioCoefficient = (Device.devicePixelRatio > 2) ? 0.0 : 0.05;
    double textFontCoefficient =
        ((Device.get().isPhone) ? 1.0 : 2.0) + pixelRatioCoefficient;
    circleTwoFontSize *= textFontCoefficient;
    circleThreeFontSize *= textFontCoefficient;
  }

  @override
  State<StatefulWidget> createState() {
    return _ConcentricChartState();
  }
}

class _ConcentricChartState extends State<ConcentricChart> {
  List<PieChartItem> circleOneItems = List.empty(growable: true);
  List<PieChartItem> circleTwoItems = List.empty(growable: true);
  List<PieChartItem> circleThreeItems = List.empty(growable: true);

  List<Center> rotatablePies = List.empty(growable: true);
  late PieInfo circleOnePie;
  late PieInfo circleTwoPie;
  late PieInfo circleThreePie;

  List<String> checkCircleOneForSpaces(List<String> list) {
    List<String> newList = List.empty(growable: true);
    for (String currString in list) {
      newList.add(replaceSpaceWithNewLine(currString));
    }
    return newList;
  }

  String replaceSpaceWithNewLine(String string) {
    return string.replaceAll(" ", '\n');
  }

  @override
  void didChangeDependencies() {
    int proportionIndex = (widget.numberOfRings == 3) ? 0 : 1;
    double circleOneProportion =
        widget.circleOneRadiusProportions[proportionIndex];
    double circleTwoProportion =
        widget.circleTwoRadiusProportions[proportionIndex];
    double circleThreeProportion =
        widget.circleThreeRadiusProportions[proportionIndex];

    if (Device.get().isAndroid && widget.numberOfRings == 2) {
      circleOneProportion -= 0.1;
    } else if (Device.get().isAndroid && widget.numberOfRings == 3) {
      circleOneProportion -= 0.08;
      circleTwoProportion -= 0.1;
    }

    if (Device.get().isTablet) {
      circleOneProportion += 0.05;
      circleTwoProportion += 0.1;
    }

    double circleTwoTextRadius = (Device.screenWidth / 2) -
        (Device.screenWidth / ((widget.numberOfRings == 2) ? 10 : 5)) +
        widget.circleTwoTextPixelOffset;

    double circleThreeTextRadius = (Device.screenWidth / 2) -
        (Device.screenWidth / ((widget.numberOfRings == 2) ? 0.0 : 12)) +
        widget.circleThreeTextPixelOffset;

    circleOnePie = PieInfo(
      pieHeightCoefficient: widget.height * circleOneProportion,
      //In names circle - is a coefficient
      textRadius: widget.circleOneTextRadiusProportion,
      items: circleOneItems,
      currRingNum: 1,
      textSize: widget.circleOneFontSize,
      textColor: widget.circleOneFontColor,
    );

    circleTwoPie = PieInfo(
      pieHeightCoefficient: widget.height * circleTwoProportion,
      items: circleTwoItems,
      textRadius: circleTwoTextRadius,
      currRingNum: 2,
      textSize: widget.circleTwoFontSize,
      textColor: widget.circleTwoFontColor,
    );

    circleThreePie = PieInfo(
      pieHeightCoefficient: widget.height * circleThreeProportion,
      items: circleThreeItems,
      textRadius: circleThreeTextRadius,
      currRingNum: 3,
      textSize: widget.circleThreeFontSize,
      textColor: widget.circleThreeFontColor,
    );

    if (widget.numberOfRings == 3) {
      rotatablePies.add(makePieChart(circleThreePie, circleThreeBounds));
    }
    rotatablePies.add(makePieChart(circleTwoPie, circleTwoBounds));
    rotatablePies.add(makePieChart(circleOnePie, circleOneBounds));

    super.didChangeDependencies();
  }

  @override
  void initState() {
    //THESE CHARTS SHOULD HAVE A MAX OF 8 ITEMS
    //AND A MINIMUM OF 2 ITEMS
    assert(widget.circleOneText.length > 1 && widget.circleOneText.length <= 8);
    assert(widget.circleTwoText.length > 1 && widget.circleTwoText.length <= 8);
    assert(widget.circleThreeText.length > 1 &&
        widget.circleThreeText.length <= 8);

    widget.circleOneText = checkCircleOneForSpaces(widget.circleOneText);
    for (String circleOneItem in widget.circleOneText) {
      circleOneItems.add(PieChartItem(
        name: circleOneItem,
        color: widget.circleOneColor,
        key: ValueKey(circleOneItem),
      ));
    }

    for (String circleTwoItem in widget.circleTwoText) {
      circleTwoItems.add(
        PieChartItem(
          name: circleTwoItem,
          color: widget.circleTwoColor,
        ),
      );
    }

    for (String circleThreeItem in widget.circleThreeText) {
      circleThreeItems.add(
        PieChartItem(
          name: circleThreeItem,
          color: widget.circleThreeColor,
        ),
      );
    }

    circleOneBounds = populateBounds(circleOneItems.length);
    circleTwoBounds = populateBounds(circleTwoItems.length);
    circleThreeBounds = populateBounds(circleThreeItems.length);

    super.initState();
  }

  List<double> circleOneBounds = List.empty(growable: true);
  List<double> circleTwoBounds = List.empty(growable: true);
  List<double> circleThreeBounds = List.empty(growable: true);
  populateBounds(int numItems) {
    List<double> newBounds = List.empty(growable: true);
    for (int i = 0; i <= numItems; i++) {
      newBounds.add(i / numItems);
    }
    return newBounds;
  }

  makePieChart(PieInfo pie, List<double> bounds) {
    return Center(
      child: SafeArea(
        child: RotatingPieChart(
          bounds: bounds,
          pie: pie,
          shouldHaveFluidTransition: widget.shouldHaveFluidTextTransition,
          spaceBetweenLines: widget.spaceBetweenLines,
          overflowLineLimit: widget.overflowLineLimit,
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
