import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import '../Global.dart';
import 'RotatingPieChart/Objects/PieChartItem.dart';
import 'RotatingPieChart/Objects/PieInfo.dart';
import 'RotatingPieChart/RotatingPieChart.dart';

class ConcentricChart extends StatefulWidget {
  int numberOfRings;
  double height;

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

  List<String> circleThreeText;
  Color circleThreeColor;
  Color circleThreeFontColor;
  double circleThreeFontSize;
  List<double> circleThreeRadiusProportions;

  late double namesFontSize;
  late final double outerRingsFontSize;
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
  }) {
    double pixelRatioCoefficient = (Global.isHighPixelRatio) ? 0.0 : 0.05;
    double textFontCoefficient =
        ((Global.isPhone) ? 1.0 : 2.0) + pixelRatioCoefficient;
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

  @override
  void didChangeDependencies() {
    int proportionIndex = (widget.numberOfRings == 3) ? 0 : 1;
    double circleOneProportion =
        widget.circleOneRadiusProportions[proportionIndex];
    double circleTwoProportion =
        widget.circleTwoRadiusProportions[proportionIndex];
    double circleThreeProportion =
        widget.circleThreeRadiusProportions[proportionIndex];

    double circleTwoTextRadius = 0.0;
    double circleThreeTextRadius = 0.0;

    if (widget.numberOfRings == 2) {
      if (!Global.isPhone) circleOneProportion += 0.1;
      if (Global.isHighPixelRatio) circleOneProportion -= 0.08;

      circleTwoTextRadius = (widget.height * 0.45) / 2.0;
      if (Global.isHighPixelRatio) {
        circleTwoTextRadius -= 45;
        if (Device.width > 1000 && Device.get().isIos && Global.isPhone) {
          circleTwoTextRadius += 35.0;
        }
      }
      if (!Global.isPhone) circleTwoTextRadius += 75;
      circleThreeTextRadius = 0.0;
    } else if (widget.numberOfRings == 3) {
      if (!Global.isPhone) circleOneProportion += 0.06;
      if (Global.isHighPixelRatio) {
        circleOneProportion -= 0.06;
        if (Device.width > 1000 && Device.get().isIos && Global.isPhone) {
          circleOneProportion += 0.03;
        }
      }

      if (!Global.isPhone) circleTwoProportion += 0.12;
      if (Global.isHighPixelRatio) {
        circleTwoProportion -= 0.08;
        if (Device.width > 1000 && Device.get().isIos && Global.isPhone) {
          circleTwoProportion += 0.05;
        }
      }

      circleTwoTextRadius = (widget.height * circleTwoProportion) / 2.45;
      if (!Global.isPhone) circleTwoTextRadius += 5;

      circleThreeTextRadius = (widget.height * circleTwoProportion) / 1.65;

      if (!Global.isPhone) circleThreeTextRadius += 5;
      if (Global.isHighPixelRatio) {
        circleThreeTextRadius += 5.0;
        if (Device.width > 1000 && Device.get().isIos && Global.isPhone) {
          circleThreeTextRadius += 5.0;
        }
      }
    }

    debugPrint(widget.height.toString());

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
      rotatablePies.add(makePieChart(circleThreePie));
    }
    rotatablePies.add(makePieChart(circleTwoPie));
    rotatablePies.add(makePieChart(circleOnePie));

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

    for (String circleOneItem in widget.circleOneText) {
      circleOneItems.add(PieChartItem(1, circleOneItem, widget.circleOneColor));
    }

    for (String circleTwoItem in widget.circleTwoText) {
      circleTwoItems.add(PieChartItem(1, circleTwoItem, widget.circleTwoColor));
    }

    for (String circleThreeItem in widget.circleTwoText) {
      circleThreeItems
          .add(PieChartItem(1, circleThreeItem, widget.circleThreeColor));
    }

    String iis = "";
    iis += "iiiiiiiiii"; //1
    iis += "i"; //2
    // iis += "iiiiiiiiii"; //3
    // iis += "iiiiiiiiii"; //4
    // iis += "iiiiiiiiii"; //5
    // iis += "iiiiiiiiii"; //6
    iis += "iiiiiiiiii"; //7
    // iis += "iiiiiiiiii"; //8
    //iis += "iiiiiiiiii"; //9
    //iis += "iiiiiiiiii"; //10
    iis += ""; //11
    //iis += "iiiiiiiiii"; //12
    // iis += "iiiiiiiiii"; //13
    // iis += "iiiiiiiiii"; //14
    //iis += "iiiiiiiiii"; //15
    //iis += "iiiiiiiiii";
    iis += "";
    iis += "";

    String mms = "";
    mms += "MMM";
    mms += "";
    //mms += "MMMMMMMMMM";
    //mms += "MMMMMMM";
    // mms += "MMMMMMMMMM";
    // mms += "MMMMMMMMMM";
    //mms += "MMMMMMMM";
    //mms += "MMMMMMMMMM";
    //mms += "MMMMMMMMMM";
    //mms += "MMMMMMMMMM";
    mms += "M";

    String aas = "";
    //aas += "a a a a a a a a a a";
    //aas += " a a a a a a a a a a";
    //aas += " a a a a a";
    //aas += "a a a a a a a a a a";
    //aas += " a a a a a a a a a a";
    aas += " a a a a";
    //aas += " a a a a a a a a a a";
    //aas += " a a a a a a a a a a";
    //aas += " a a a a";

    String bops = "bop bop bop";
    //bops += " bop bop bop";
    //bops += " bop bop bop bop bop";
    //bops += " bop bop bop bop bop";
    //bops += " bop bop bop bop bop bop";
    //bops += " bop bop bop";
    // bops += " bop bop bop bop bop bop";
    //bops += " bop bop bop bop bop bop";
    //bops += " bop bop bop bop bop";
    // bops += " bop bop bop bop bop";
    // bops += " bop bop bop bop bop";
    bops += "";

    populateBounds(circleOneItems.length);

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
