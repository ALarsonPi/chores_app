import 'dart:convert';
import 'dart:math';
import 'package:chore_app/Widgets/RotatingPieChart/TextPainters/ArcText.dart';
import 'package:chore_app/Widgets/RotatingPieChart/Objects/PieChartItem.dart';
import 'package:chore_app/Widgets/RotatingPieChart/PiePainter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  List<String> finalStringsOverflow = List.empty(growable: true);

  late double userChosenRadius;
  late int numChunks;
  late double CHUNK_SIZE;

  //When using 'l' or 'i' as the smallest letter
  final double WIDTH_OF_SMALLEST_LETTER = 0.1145861761;
  final double WIDTH_OF_SPACE = 0.16017116006731802;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _animation = Tween(begin: 0.0, end: 2.0 * pi).animate(_controller);
    _controller.animateTo(2 * pi, duration: const Duration(seconds: 5));
    isNames = widget.isNames;
    userChosenRadius = widget.userChosenRadiusForText;
    numChunks = widget.items.length;
    CHUNK_SIZE = (2 * pi / numChunks);
    setUpFinalStrings();
    super.initState();
  }

  double radiansToDegrees(double radians) {
    return radians * 180 / pi;
  }

  final _testPainter = TextPainter(textDirection: TextDirection.ltr);
  double getAlphaForSpecificLetter(String letter) {
    _testPainter.text = TextSpan(
        text: letter, style: const TextStyle(fontSize: 14, color: Colors.red));
    _testPainter.layout(
      minWidth: 0,
      maxWidth: double.maxFinite,
    );
    final double d = _testPainter.width;
    final double alpha = 2 * asin(d / (2 * userChosenRadius));
    return alpha;
  }

  double getTotalPhraseAlpha(String word) {
    double sum = 0;
    for (var currLetter in word.characters) {
      sum += getAlphaForSpecificLetter(currLetter);
    }
    return sum;
  }

  double getTotalPaddingAsIntegerIncrements(
      double totalWordAlpha, double chunkAlpha) {
    return ((chunkAlpha - totalWordAlpha) / WIDTH_OF_SPACE).ceilToDouble();
  }

  String addPaddingToInitialPhrase(
      String initialPhrase, double leftPaddingNum, double rightPaddingNum) {
    String leftPadding = "";
    String rightPadding = "";
    for (int j = 0; j < leftPaddingNum; j++) {
      leftPadding += "  ";
    }
    for (int k = 0; k < rightPaddingNum; k++) {
      rightPadding += "  ";
    }
    String finalString = "$leftPadding$initialPhrase$rightPadding  ";
    return finalString;
  }

  setUpFinalStrings() async {
    //Step 1. Get all alphas for each letter in the allotted word
    List<double> chunkAlpha = List.empty(growable: true);
    for (var item in widget.items) {
      chunkAlpha.add(getTotalPhraseAlpha(item.name));
      finalStrings.add("");
      finalStringsOverflow.add("");
    }

    //Step 2. Find the amount of padding allowed by this word
    for (int i = 0; i < chunkAlpha.length; i++) {
      chunkAlpha[i] =
          getTotalPaddingAsIntegerIncrements(chunkAlpha[i], CHUNK_SIZE);
    }

    //Step 3. Break the total padding into left and right, favoring the right side
    // if there is a remainder
    List<double> leftPaddingNums = List.empty(growable: true);
    List<double> rightPaddingNums = List.empty(growable: true);
    for (int i = 0; i < chunkAlpha.length; i++) {
      double remainder = chunkAlpha[i] % 2;
      chunkAlpha[i] -= remainder;
      double splitNum = chunkAlpha[i] / 2;

      //Take Care of Overflow Behavior
      if (splitNum == 1 || widget.items[i].name.length > 15) {
        splitNum = 0;
        List<String> splitPhraseParts =
            splitPhraseForOverflow(widget.items[i].name);
        List<String> repaddedPhraseParts =
            reapplyPaddingForOverflow(splitPhraseParts);
        finalStrings[i] = repaddedPhraseParts[0];
        finalStringsOverflow[i] = repaddedPhraseParts[1];
      }

      leftPaddingNums.add(splitNum);
      rightPaddingNums.add(splitNum + remainder);
    }

    //Step 4. Form the final string, using spaces as the padding
    for (int i = 0; i < chunkAlpha.length; i++) {
      String finalString = addPaddingToInitialPhrase(
          widget.items[i].name, leftPaddingNums[i], rightPaddingNums[i]);
      if (finalStringsOverflow[i].isEmpty) {
        finalStrings[i] = finalString;
      }
    }

    //Things to DO
    //DONE 1. Check if overflow as a concept would work (would it paint correctly)
    //DONE 2. Decide on when I want a phrase to overflow
    /*
         Should overflow maybe if the padding on the left runs out 
         that's when it slams against the wall of it's chunk
         So let's try that first
         and if needed I can add a bit more leeway saying if the left padding 
         is one or two then overflow
        */
    //DONE 3. Implement a phrase overflow method
    /*
        Go to the middle character and find the next white space 
        If there is no white space to the left and find the one before

        Split the phrase at that white space
        The left part will have white space added on left and right 
             replacing the number of characters lost
        Then take the right part. We will use it as the inner phrase
        Then somehow figure out how to add the correct spacing for 
             this inner phrase portion
      */
    //DONE 4. Send in final strings and finalStringsOverflow (empty if none)
    //5. Decide on what length of strings should be allowed for the user to type in
    // we would then cap that amount when the user is inputting the amount
  }

  List<String> splitPhraseForOverflow(String phraseToSplit) {
    List<String> phraseParts = List.empty(growable: true);
    int i = (phraseToSplit.length / 2).floor();
    while (i != phraseToSplit.length) {
      if (phraseToSplit[i] == " " ||
          phraseToSplit[i] == "\t" ||
          phraseToSplit[i] == "\n") {
        phraseParts.add(phraseToSplit.substring(0, i).trim());
        phraseParts.add(phraseToSplit.substring(i).trim());
      }
      i++;
    }
    if (phraseParts.isEmpty) {
      i = (phraseToSplit.length / 2).floor();
      while (i != -1) {
        if (phraseToSplit[i] == " " ||
            phraseToSplit[i] == "\t" ||
            phraseToSplit[i] == "\n") {
          phraseParts.add(phraseToSplit.substring(0, i).trim());
          phraseParts.add(phraseToSplit.substring(i).trim());
        }
        i--;
      }
    }
    if (phraseParts.isEmpty) {
      i = (phraseToSplit.length / 2).floor();
      phraseParts.add('${phraseToSplit.substring(0, i).trim()}-');
      phraseParts.add(phraseToSplit.substring(i).trim());
    }
    return phraseParts;
  }

  List<String> reapplyPaddingForOverflow(List<String> phraseParts) {
    List<double> numTotalPaddingElements = List.empty(growable: true);
    numTotalPaddingElements.add(getTotalPaddingAsIntegerIncrements(
        getTotalPhraseAlpha(phraseParts[0]), CHUNK_SIZE));
    numTotalPaddingElements.add(getTotalPaddingAsIntegerIncrements(
        getTotalPhraseAlpha(phraseParts[1]), CHUNK_SIZE));

    List<double> leftPaddingNums = List.empty(growable: true);
    List<double> rightPaddingNums = List.empty(growable: true);
    for (int i = 0; i < 2; i++) {
      double remainder = numTotalPaddingElements[i] % 2;
      numTotalPaddingElements[i] -= remainder;
      double splitNum = numTotalPaddingElements[i] / 2;
      leftPaddingNums.add(splitNum);
      rightPaddingNums.add(splitNum + remainder);
    }

    phraseParts[0] = addPaddingToInitialPhrase(
        phraseParts[0], leftPaddingNums[0], rightPaddingNums[0]);
    phraseParts[1] = addPaddingToInitialPhrase(
        phraseParts[1], leftPaddingNums[1], rightPaddingNums[1]);
    return phraseParts;
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
                        const TextStyle(fontSize: 22, color: Colors.red),
                        _animation.value + 1.57079632679,
                        finalStrings,
                        finalStringsOverflow,
                        numChunks,
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
