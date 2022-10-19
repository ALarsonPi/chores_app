import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import '../Global.dart';
import 'RotatingPieChart/Objects/PieChartItem.dart';
import 'RotatingPieChart/Objects/PieInfo.dart';
import 'RotatingPieChart/RotatingPieChart.dart';

class ConcentricChart extends StatefulWidget {
  int numberOfRings;

  List<String> circleOneText;
  Color circleOneColor;
  Color circleOneFontColor;
  double circleOneFontSize;
  double circleOneRadiusProportion;

  List<String> circleTwoText;
  Color circleTwoColor;
  Color circleTwoFontColor;
  double circleTwoFontSize;

  List<String> circleThreeText;
  Color circleThreeColor;
  Color circleThreeFontColor;
  double circleThreeFontSize;

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
    this.circleOneRadiusProportion = 0.6,
    this.circleOneFontSize = 8.0,
    this.circleTwoFontSize = 14.0,
    this.circleThreeFontSize = 14.0,
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
  late PieInfo namesPie;
  late PieInfo firstPie;
  late PieInfo secondPie;

  @override
  void didChangeDependencies() {
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
      if (Global.isHighPixelRatio) {
        ring2TextRadius -= 45;
        if (Device.width > 1000 && Device.get().isIos && Global.isPhone) {
          ring2TextRadius += 35.0;
        }
      }
      if (!Global.isPhone) ring2TextRadius += 75;
      ring3TextRadius = 0.0;
    } else if (widget.numberOfRings == 3) {
      nameProportion = 0.25;

      if (!Global.isPhone) nameProportion += 0.06;
      if (Global.isHighPixelRatio) {
        nameProportion -= 0.06;
        if (Device.width > 1000 && Device.get().isIos && Global.isPhone) {
          nameProportion += 0.03;
        }
      }

      pie1Proportion = 0.4;
      if (!Global.isPhone) pie1Proportion += 0.12;
      if (Global.isHighPixelRatio) {
        pie1Proportion -= 0.08;
        if (Device.width > 1000 && Device.get().isIos && Global.isPhone) {
          pie1Proportion += 0.05;
        }
      }

      pie2Proportion = 0.9;

      ring2TextRadius =
          (MediaQuery.of(context).size.height * pie1Proportion) / 2.45;
      if (!Global.isPhone) ring2TextRadius += 5;

      ring3TextRadius =
          (MediaQuery.of(context).size.height * pie1Proportion) / 1.65;

      if (!Global.isPhone) ring3TextRadius += 5;
      if (Global.isHighPixelRatio) {
        ring3TextRadius += 5.0;
        if (Device.width > 1000 && Device.get().isIos && Global.isPhone) {
          ring3TextRadius += 5.0;
        }
      }
    }

    namesPie = PieInfo(
      pieHeightCoefficient: MediaQuery.of(context).size.height * nameProportion,
      //In names circle - is a coefficient
      textRadius: widget.circleOneRadiusProportion,
      items: circleOneItems,
      currRingNum: 1,
      textSize: widget.circleOneFontSize,
      textColor: widget.circleOneFontColor,
    );

    firstPie = PieInfo(
      pieHeightCoefficient: MediaQuery.of(context).size.height * pie1Proportion,
      items: circleTwoItems,
      textRadius: ring2TextRadius,
      currRingNum: 2,
      textSize: widget.circleTwoFontSize,
      textColor: widget.circleTwoFontColor,
    );

    secondPie = PieInfo(
      pieHeightCoefficient: MediaQuery.of(context).size.height * pie2Proportion,
      items: circleThreeItems,
      textRadius: ring3TextRadius,
      currRingNum: 3,
      textSize: widget.circleThreeFontSize,
      textColor: widget.circleThreeFontColor,
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
