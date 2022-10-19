import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import '../Global.dart';
import 'RotatingPieChart/Objects/PieChartItem.dart';
import 'RotatingPieChart/Objects/PieInfo.dart';
import 'RotatingPieChart/RotatingPieChart.dart';

class ConcentricChart extends StatefulWidget {
  int numberOfRings;

  Color circleOneColor;
  Color circleOneFontColor;
  double circleOneFontSize;
  double circleOneRadiusProportion;

  Color circleTwoColor;
  Color circleTwoFontColor;
  double circleTwoFontSize;

  Color circleThreeColor;
  Color circleThreeFontColor;
  double circleThreeFontSize;

  late double namesFontSize;
  late final double outerRingsFontSize;
  ConcentricChart({
    super.key,
    required this.numberOfRings,
    required this.circleOneColor,
    required this.circleTwoColor,
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
  List<PieChartItem> pieNamesItems = List.empty(growable: true);
  List<PieChartItem> pieOneItems = List.empty(growable: true);
  List<PieChartItem> pieTwoItems = List.empty(growable: true);

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
      items: pieNamesItems,
      currRingNum: 1,
      textSize: widget.circleOneFontSize,
      textColor: widget.circleOneFontColor,
    );

    firstPie = PieInfo(
      pieHeightCoefficient: MediaQuery.of(context).size.height * pie1Proportion,
      items: pieOneItems,
      textRadius: ring2TextRadius,
      currRingNum: 2,
      textSize: widget.circleTwoFontSize,
      textColor: widget.circleTwoFontColor,
    );

    secondPie = PieInfo(
      pieHeightCoefficient: MediaQuery.of(context).size.height * pie2Proportion,
      items: pieTwoItems,
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
    //AND A MINIMUM OF 3 ITEMS

    Color namesColor = widget.circleOneColor;
    Color pieOneColor = widget.circleTwoColor;
    Color pieTwoColor = widget.circleThreeColor;

    // Color? namesColor = Colors.red[200];
    // Color? pieOneColor = Colors.red[400];
    // Color? pieTwoColor = Colors.red[700];

    // Color? namesColor = Colors.purple[100];
    // Color? pieOneColor = Colors.purple[300];
    // Color? pieTwoColor = Colors.purple[500];

    // Color? namesColor = Colors.green[200];
    // Color? pieOneColor = Colors.green[500];
    // Color? pieTwoColor = Colors.green[700];

    // Color? namesColor = Colors.orange[200];
    // Color? pieOneColor = Colors.orange[500];
    // Color? pieTwoColor = Colors.orange[700];

    pieNamesItems.add(PieChartItem(1, "Jacob", namesColor));
    pieNamesItems.add(PieChartItem(1, "Jonathan", namesColor));
    pieNamesItems.add(PieChartItem(1, "James", namesColor));
    pieNamesItems.add(PieChartItem(1, "Adopted\nHobo", namesColor));
    // pieNamesItems.add(PieChartItem(1, "John\nCina", namesColor));
    // pieNamesItems.add(PieChartItem(1, "Jamison\nIII", namesColor));
    // pieNamesItems.add(PieChartItem(1, "Santa\nClaus", namesColor));
    // pieNamesItems.add(PieChartItem(1, "Abe\nLincoln", namesColor));

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

    pieOneItems.add(PieChartItem(1, bops, pieOneColor));
    pieOneItems.add(PieChartItem(
        1,
        "Floorsssssssssssssssssssssssssssssssssssssssssssssssssssssssss",
        pieOneColor));
    pieOneItems.add(PieChartItem(1, "Run around good sir", pieOneColor));
    pieOneItems.add(PieChartItem(1, "Clean the Toilet :)", pieOneColor));
    // pieOneItems.add(PieChartItem(1, "Don't die", pieOneColor));
    // pieOneItems.add(PieChartItem(1, "Wash the fat dogs", pieOneColor));
    // pieOneItems.add(PieChartItem(1, "Clean up after", pieOneColor));
    // pieOneItems.add(PieChartItem(1, "Give a speech", pieOneColor));

    pieTwoItems.add(PieChartItem(1, bops, pieTwoColor));
    pieTwoItems.add(PieChartItem(
        1,
        "Clean Oven with all your might; mind; and strength with an eye single to the glory of God",
        pieTwoColor));
    pieTwoItems.add(PieChartItem(
        1,
        "Clean Oven with all your might, mind, and strength with an eye single to the glory of God",
        pieTwoColor));
    pieTwoItems.add(PieChartItem(1, "Shovel Snow", pieTwoColor));
    // pieTwoItems.add(PieChartItem(1, "Grow Potatoes", pieTwoColor));
    // pieTwoItems.add(PieChartItem(1, "Travel to Russia", pieTwoColor));
    // pieTwoItems.add(PieChartItem(1, "Give coal to naughty kids", pieTwoColor));
    // pieTwoItems.add(PieChartItem(1, "Beat the South", pieTwoColor));

    populateBounds(pieNamesItems.length);

    //In terms of getting a formula for how many letters can be input for a
    // certain chart - it will require 3 things
    // 1. Num Items (primarily)
    // 2. Type of device (tablet/phone)
    // 3. Pixel/Aspect Ratio
    // 4. And will probably need a safe zone (and I'll err on the safe side)
    // Might end up making it something that I calculate ahead of time for a
    // base value and then using the device type and aspect ratio to
    // tweak it slightly

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
