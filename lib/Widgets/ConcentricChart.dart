import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'RotatingPieChart/Objects/PieChartItem.dart';
import 'RotatingPieChart/Objects/PieInfo.dart';
import 'RotatingPieChart/RotatingPieChart.dart';

class ConcentricChart extends StatefulWidget {
  int numberOfRings;
  double width;
  double spaceBetweenLines;
  List<Color> linesColors;

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
  List<double> circleTwoTextProportions;
  double circleTwoTextPixelOffset;

  List<String> circleThreeText;
  Color circleThreeColor;
  Color circleThreeFontColor;
  double circleThreeFontSize;
  List<double> circleThreeRadiusProportions;
  List<double> circleThreeTextProportions;
  double circleThreeTextPixelOffset;

  bool shouldHaveFluidTextTransition;
  int overflowLineLimit;
  bool shouldTextCenterVertically;

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
    this.width = 1080,
    this.circleOneTextRadiusProportion = 0.6,
    this.circleOneFontSize = 8.0,
    this.circleTwoFontSize = 14.0,
    this.circleThreeFontSize = 14.0,
    this.circleOneRadiusProportions = const [0.4, 0.6],
    this.circleTwoRadiusProportions = const [0.7, 1.0],
    this.circleTwoTextProportions = const [0.25, 0.4],
    this.circleThreeRadiusProportions = const [1.0, 0],
    this.circleThreeTextProportions = const [0.4, 0],
    this.circleTwoTextPixelOffset = 0.0,
    this.circleThreeTextPixelOffset = 0.0,
    this.spaceBetweenLines = 20,
    this.shouldHaveFluidTextTransition = true,
    this.shouldTextCenterVertically = true,
    this.overflowLineLimit = 2,
    this.linesColors = const [Colors.black, Colors.black, Colors.black],
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

  double getProportionValue(double radius) {
    if (radius != 1.0 && Device.devicePixelRatio > 2.0) {
      return radius *
          (1 + (Device.devicePixelRatio.ceil() - Device.devicePixelRatio));
    } else {
      return radius;
    }
  }

  @override
  void didChangeDependencies() {
    int proportionIndex = (widget.numberOfRings == 3) ? 0 : 1;
    double circleOneProportion =
        getProportionValue(widget.circleOneRadiusProportions[proportionIndex]);

    double circleTwoProportion =
        getProportionValue(widget.circleTwoRadiusProportions[proportionIndex]);
    double circleTwoTextProportion =
        getProportionValue(widget.circleTwoTextProportions[proportionIndex]);

    double circleThreeProportion = getProportionValue(
        widget.circleThreeRadiusProportions[proportionIndex]);
    double circleThreeTextProportion =
        getProportionValue(widget.circleThreeTextProportions[proportionIndex]);

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

    // double circleTwoTextRadius = (Device.screenWidth / 2) -
    //     (Device.screenWidth / ((widget.numberOfRings == 2) ? 10 : 5)) +
    //     widget.circleTwoTextPixelOffset;

    double ringOnewidth = widget.width * circleOneProportion;
    double ringTwowidth = widget.width * circleTwoProportion;
    double ringThreewidth = widget.width * circleThreeProportion;

    double ringTwoTextRadius = widget.width * circleTwoTextProportion;
    double ringThreeTextRadius = widget.width * circleThreeTextProportion;

    // double ringTwoMiddlewidth = (ringOnewidth + ringTwowidth) / 2;
    // double ringThreeMiddlewidth = (ringTwowidth + ringThreewidth) / 2;

    double ringTwoMiddlewidth = (ringTwoTextRadius);
    double ringThreeMiddlewidth = (ringThreeTextRadius);

    circleOnePie = PieInfo(
      width: ringOnewidth,
      //In names circle - is a coefficient
      textRadius: widget.circleOneTextRadiusProportion,
      items: circleOneItems,
      linesColor: widget.linesColors[0],
      ringNum: 1,
      textSize: widget.circleOneFontSize,
      textColor: widget.circleOneFontColor,
      ringBorders: [
        0,
        ringOnewidth,
      ],
    );

    circleTwoPie = PieInfo(
      width: ringTwowidth,
      items: circleTwoItems,
      textRadius: ringTwoMiddlewidth,
      linesColor: widget.linesColors[1],
      ringNum: 2,
      textSize: widget.circleTwoFontSize,
      textColor: widget.circleTwoFontColor,
      ringBorders: [
        ringOnewidth,
        ringTwowidth * (1 + circleTwoProportion),
      ],
    );

    if (widget.numberOfRings == 3) {
      circleThreePie = PieInfo(
          width: ringThreewidth,
          items: circleThreeItems,
          textRadius: ringThreeMiddlewidth,
          linesColor: widget.linesColors[2],
          ringNum: 3,
          textSize: widget.circleThreeFontSize,
          textColor: widget.circleThreeFontColor,
          ringBorders: [
            ringTwowidth,
            ringThreewidth,
          ]);
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
          linesColor: pie.linesColor,
          shouldHaveFluidTransition: widget.shouldHaveFluidTextTransition,
          shouldCenterTextVertically: widget.shouldTextCenterVertically,
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
