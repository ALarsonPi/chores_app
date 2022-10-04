import 'dart:math';
import 'package:chore_app/RotatingPieChart/TextPainters/ArcText.dart';
import 'package:chore_app/RotatingPieChart/Objects/PieChartItem.dart';
import 'package:chore_app/RotatingPieChart/PiePainter.dart';
import 'package:flutter/material.dart';

import 'TextPainters/NameTextPainter.dart';

class RotatingPieChart extends StatelessWidget {
  final double accellerationFactor;
  final List<PieChartItem> items;
  final PieChartItemToText toText;
  final double sizeOfChart;
  final List<double> bounds;
  final bool isNames;
  final double userChosenRadiusForText;

  const RotatingPieChart(
      {Key? key,
      this.accellerationFactor = 1.0,
      required this.items,
      required this.toText,
      required this.bounds,
      required this.isNames,
      required this.userChosenRadiusForText,
      this.sizeOfChart = 250})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: sizeOfChart,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: _RotatingPieChartInternal(
            bounds: bounds,
            items: items,
            toText: toText,
            accellerationFactor: accellerationFactor,
            isNames: isNames,
            userChosenRadiusForText: userChosenRadiusForText,
          ),
        ),
      ),
    );
  }
}

class _RotationEndSimulation extends Simulation {
  final double initialVelocity;
  final double initialPosition;
  final double accelleration;
  final List<double> bounds;

  _RotationEndSimulation({
    required this.initialVelocity,
    required double decelleration,
    required this.initialPosition,
    required this.bounds,
  }) : accelleration = decelleration * -1.0;

  @override
  double dx(double time) => initialVelocity + (accelleration * time);

  @override
  bool isDone(double time) {
    bool hasFinishedRotation =
        initialVelocity > 0 ? dx(time) < 0.001 : dx(time) > -0.001;
    return hasFinishedRotation;
  }

  List<double> getCurrentBounds(double xPosition) {
    List<double> currentBounds = List.empty(growable: true);
    //Go Backwards
    if (xPosition >= 0.5) {
      for (int i = bounds.length - 1; i > 0; i--) {
        if (bounds[i] <= xPosition) {
          currentBounds.add(bounds[i]);
          currentBounds.add(bounds[i + 1]);
        }
      }
    }
    //Go forwards
    else {
      for (int i = 0; i < bounds.length; i++) {
        if (bounds[i] > xPosition) {
          currentBounds.add(bounds[i]);
          currentBounds.add(bounds[i - 1]);
          break;
        }
      }
    }
    return currentBounds;
  }

  double getClosestBound(double xPosition) {
    List<double> lowHighBounds = getCurrentBounds(xPosition);
    if ((xPosition - lowHighBounds[0]).abs() <
        (xPosition - lowHighBounds[1]).abs()) {
      return lowHighBounds[0];
    } else {
      return lowHighBounds[1];
    }
  }

  @override
  double x(double time) {
    double xPosition = (initialPosition +
            (initialVelocity * time) +
            (accelleration * time * time / 2)) %
        1.0;
    if (initialVelocity > 0 ? dx(time) < 0.003 : dx(time) > -0.003) {
      xPosition = getClosestBound(xPosition);
      if (xPosition == 1) xPosition = 0;
    }
    return xPosition;
  }
}

class _RotatingPieChartInternal extends StatefulWidget {
  final double accellerationFactor;
  final List<PieChartItem> items;
  final PieChartItemToText toText;
  final List<double> bounds;
  final bool isNames;
  final double userChosenRadiusForText;

  const _RotatingPieChartInternal({
    Key? key,
    this.accellerationFactor = 1.0,
    required this.items,
    required this.toText,
    required this.bounds,
    required this.isNames,
    required this.userChosenRadiusForText,
  }) : super(key: key);

  @override
  _RotatingPieChartInternalState createState() =>
      _RotatingPieChartInternalState();
}

class _RotatingPieChartInternalState extends State<_RotatingPieChartInternal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late bool isNames;
  List<String> finalStrings = List.empty(growable: true);
  late double userChosenRadius;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _animation = Tween(begin: 0.0, end: 2.0 * pi).animate(_controller);
    _controller.animateTo(2 * pi, duration: const Duration(seconds: 5));
    isNames = widget.isNames;
    userChosenRadius = widget.userChosenRadiusForText;
    setUpFinalStrings();
    super.initState();
  }

  final _testPainter = TextPainter(textDirection: TextDirection.ltr);
  double getAlphaForSpecificLetter(String letter) {
    _testPainter.text = TextSpan(
        text: letter, style: const TextStyle(fontSize: 26, color: Colors.red));
    _testPainter.layout(
      minWidth: 0,
      maxWidth: double.maxFinite,
    );
    final double d = _testPainter.width;
    final double alpha = 2 * asin(d / (2 * userChosenRadius));
    return alpha;
  }

  setUpFinalStrings() async {
    //Step 1. Find chunck size
    double chunkSizeInRads = (2 * pi / widget.items.length);

    //Step 2. Get all alphas for each letter in the allotted word
    List<double> chunkAlpha = List.empty(growable: true);
    for (var item in widget.items) {
      double sum = 0;
      for (var currLetter in item.name.characters) {
        sum += getAlphaForSpecificLetter(currLetter);
      }
      chunkAlpha.add(sum);
    }

    //debugPrint("chunkWordSums: " + chunkAlpha.toString());

    //When using 'l' or 'i' as the smallest letter
    const double WIDTH_OF_SMALLEST_LETTER = 0.1145861761;
    const double WIDTH_OF_SPACE = 0.16017116006731802;

    //Step 3. Find the amount of padding allowed by this word
    //cut in half representing what can be done on each side
    for (int i = 0; i < chunkAlpha.length; i++) {
      //chunk sum becomes the new padding value
      //used same array to save space and increase speed
      chunkAlpha[i] =
          ((chunkSizeInRads - chunkAlpha[i]) / WIDTH_OF_SPACE).floorToDouble();
    }

    //debugPrint("total padding: " + chunkAlpha.toString());

    //Step 4. Break the total padding into left and right, favoring the right side
    // if there is a remainder
    List<double> leftPaddingNums = List.empty(growable: true);
    List<double> rightPaddingNums = List.empty(growable: true);
    for (int i = 0; i < chunkAlpha.length; i++) {
      double remainder = chunkAlpha[i] % 2;
      chunkAlpha[i] -= remainder;
      double splitNum = chunkAlpha[i] / 2;
      leftPaddingNums.add(splitNum);
      rightPaddingNums.add(splitNum + remainder);
    }

    // debugPrint("Left Padding : " + leftPaddingNums.toString());
    // debugPrint("Right Padding : " + rightPaddingNums.toString());

    //Step 5. Form the final string, using spaces as the padding
    // this will be the easiest to code / follow as code, though maybe a little
    // less exact than using the smallest letter 'l'. Could still implement that in
    // the future if needed

    for (int i = 0; i < chunkAlpha.length; i++) {
      String leftPadding = "";
      String rightPadding = "";
      for (int j = 0; j < leftPaddingNums[i]; j++) {
        leftPadding += " ";
      }
      for (int k = 0; k < rightPaddingNums[i]; k++) {
        rightPadding += " ";
      }
      if (i == 0) {
        leftPadding = "";
      }
      String finalString = leftPadding + widget.items[i].name + rightPadding;
      finalStrings.add(finalString);
    }

    for (int i = 0; i < widget.items.length; i++) {
      //debugPrint(items[i].name);
    }
    //debugPrint("Final Strings = " + finalStrings.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late Offset lastDirection;

  Offset getDirection(Offset globalPosition) {
    RenderBox? box = context.findRenderObject() as RenderBox?;
    Offset? offset = box?.globalToLocal(globalPosition);
    Offset center =
        Offset(context.size!.width / 2.0, context.size!.height / 2.0);
    return offset! - center;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(userChosenRadius.toString());
    debugPrint(finalStrings.toString());
    return GestureDetector(
      onPanDown: (details) {
        lastDirection = getDirection(details.globalPosition);
      },
      onPanUpdate: (details) {
        Offset newDirection = getDirection(details.globalPosition);
        double diff = newDirection.direction - lastDirection.direction;

        var value = _controller.value + (diff / pi / 2);
        _controller.value = value % 1.0;
        lastDirection = newDirection;
      },
      onPanEnd: (details) {
        // non-angular velocity
        Offset velocity = details.velocity.pixelsPerSecond;

        var top =
            (lastDirection.dx * velocity.dy) - (lastDirection.dy * velocity.dx);
        var bottom = (lastDirection.dx * lastDirection.dx) +
            (lastDirection.dy * lastDirection.dy);

        var angularVelocity = top / bottom;
        var angularRotation = angularVelocity / pi / 2;
        var decelleration = angularRotation * widget.accellerationFactor;
        //snapTo(30);
        _controller.animateWith(
          _RotationEndSimulation(
            bounds: widget.bounds,
            decelleration: decelleration,
            initialPosition: _controller.value,
            initialVelocity: angularRotation,
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, widget) {
          return Stack(
            fit: StackFit.passthrough,
            children: [
              Transform.rotate(
                angle: _animation.value,
                child: widget,
              ),
              CustomPaint(
                painter: (!isNames)
                    ? ArcTextPainter(
                        userChosenRadius,
                        "false",
                        const TextStyle(fontSize: 26, color: Colors.red),
                        _animation.value,
                        finalStrings,
                      )
                    : PieTextPainter(
                        items: this.widget.items,
                        rotation: _animation.value,
                        toText: this.widget.toText,
                      ),
              )
            ],
          );
        },
        child: CustomPaint(
          painter: PieChartPainter(
            items: widget.items,
          ),
        ),
      ),
    );
  }
}
