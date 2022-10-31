import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'RotatingPieChart/Objects/PieChartItem.dart';
import 'RotatingPieChart/Objects/PieInfo.dart';
import 'RotatingPieChart/RotatingPieChart.dart';

class ConcentricChart extends StatefulWidget {
  /// Number of Rings in the chart, must be either TWO or THREE
  int numberOfRings;

  /// Width of the chart, often the entire width of the screen for maximum radius
  double width;

  /// Amount of space (pixels) between each line of text
  double spaceBetweenLines;

  /// Variable that controls whether or not the text in the bottom half will
  /// be flipped rightside up rather than upside down
  /// Used in conjunction with [shouldHaveFluidTextTransition]
  bool shouldFlipText;

  /// Allow for fluid text transition
  /// If true (and [shouldFlipText] is true) then
  /// text will flip when the median of the segment crosses the equator/zero line
  /// If false (and [shouldFlipText] is true) then
  /// text will remain unflipped and unchanged while spinning the circle, and flip
  /// to the correct position after the user stops spinning
  bool shouldHaveFluidTextTransition;

  /// Number of lines at which the overflow should stop overflowing
  /// Ex. value of 2 will allow for only two lines of text in each ring
  /// Anything else that would have overflowed will be put into the last line
  int overflowLineLimit;

  /// If true, will center text for lines with more than one line
  bool shouldTextCenterVertically;

  /// Color of the border of the rings and segments
  List<Color> linesColors;

  /// The proportion at which the overflow should occur [0.0-1.0]
  /// Basically, how much padding to allow on either side of your text
  /// Larger the proportion, the larger the amount of padding
  double chunkOverflowLimitProportion;

  /// The list of phrases to use in circle one
  /// Each phrase will go in a separate segment
  List<String> circleOneText;

  /// The color of the innermost circle
  Color circleOneColor;

  /// The color of the text in the innermost circle
  Color circleOneFontColor;

  /// The size of the text in the innermost circle
  double circleOneFontSize;

  /// The Proportion at which the text of the inner most circle should be displayed [0.0-1.0]
  /// The inner most circle is the only circle that uses a direct proportion to show the text
  /// 0.5 would have a radius half the size of the circle
  double circleOneTextRadiusProportion;

  /// The radii for the circle (not the text) of the innermost circle
  /// Typically starts at zero and goes to a certain proportion [0.0-1.0] of the width
  List<double> circleOneRadiusProportions;

  /// Text to put into the second circle (inner ring if there are 3 rings,
  /// outer ring if there are 2 rings). Each is put in it's own segment
  List<String> circleTwoText;

  /// Color of the second ring
  Color circleTwoColor;

  /// Color of the text in the second ring
  Color circleTwoFontColor;

  /// Size of the text in the second ring
  double circleTwoFontSize;

  /// Radius of the second ring (two values)
  /// First value is for ring with 3 rings, second value is for ring with 2 rings
  /// Both are proportions of the width given
  /// should be drawn [0.0-1.0]
  List<double> circleTwoRadiusProportions;

  /// Proportion of width at which to draw the text on the second ring (two values)
  /// First value is for ring with 3 rings, second value is for ring with 2 rings
  /// should be a value [0.0-1.0]
  List<double> circleTwoTextProportions;

  /// A pixel offset of the text in the second ring
  /// A positve value moves the text farther away from the center
  /// while a negative value moves the text closer to the center
  double circleTwoTextPixelOffset;

  /// Text to put into the outermost circle (only shown if ringNum == 3)
  ///  Each is put in it's own segment
  List<String> circleThreeText;

  /// The color of the outermost ring
  Color circleThreeColor;

  /// The text color in the outermost ring
  Color circleThreeFontColor;

  /// The size of the text in the outermost ring
  double circleThreeFontSize;

  /// Radius of the outermost ring (two values)
  /// First value is for ring with 3 rings
  /// second value is for ring with 2 rings (typically 0)
  /// Both are proportions of the width given
  /// should be a value [0.0-1.0]
  List<double> circleThreeRadiusProportions;

  /// Proportion of width at which to draw the text on the outermost ring (two values)
  /// First value is for ring with 3 rings
  /// second value is for ring with 2 rings (typically 0)
  /// should be a value [0.0-1.0]
  List<double> circleThreeTextProportions;

  /// A pixel offset of the text in the outermost ring
  /// A positve value moves the text farther away from the center
  /// while a negative value moves the text closer to the center
  double circleThreeTextPixelOffset;

  /// Constructor for concentric chart
  /// Required - [width], [numberOfRings], and all the general info about each
  /// ring including (text, general background color, and font color)
  /// Everything else is not required, but set to defaults
  ConcentricChart({
    super.key,
    required this.numberOfRings,
    required this.width,
    required this.circleOneText,
    required this.circleOneColor,
    required this.circleOneFontColor,
    required this.circleTwoText,
    required this.circleTwoColor,
    required this.circleTwoFontColor,
    required this.circleThreeText,
    required this.circleThreeColor,
    required this.circleThreeFontColor,
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
    this.chunkOverflowLimitProportion = 0.15,
    this.shouldFlipText = true,
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
          shouldFlipText: widget.shouldFlipText,
          linesColor: pie.linesColor,
          shouldHaveFluidTransition: widget.shouldHaveFluidTextTransition,
          shouldCenterTextVertically: widget.shouldTextCenterVertically,
          spaceBetweenLines: widget.spaceBetweenLines,
          overflowLineLimit: widget.overflowLineLimit,
          chunkOverflowLimitProportion: widget.chunkOverflowLimitProportion,
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
