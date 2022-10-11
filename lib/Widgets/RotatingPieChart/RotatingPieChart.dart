import 'dart:convert';
import 'dart:math';
import 'package:chore_app/Widgets/RotatingPieChart/Objects/PieInfo.dart';
import 'package:chore_app/Widgets/RotatingPieChart/TextPainters/ArcText.dart';
import 'package:chore_app/Widgets/RotatingPieChart/Objects/PieChartItem.dart';
import 'package:chore_app/Widgets/RotatingPieChart/PiePainter.dart';
import 'package:flutter/material.dart';

import '../../Global.dart';
import 'RotationEndSimulation.dart';
import 'TextPainters/NameTextPainter.dart';

class RotatingPieChart extends StatelessWidget {
  final double accellerationFactor;
  late List<PieChartItem> items;
  late double sizeOfChart;
  final List<double> bounds;
  late bool isNames;
  late double userChosenRadiusForText;
  final PieInfo pie;

  RotatingPieChart({
    super.key,
    this.accellerationFactor = 1.0,
    required this.bounds,
    required this.pie,
  }) {
    items = pie.textAndAngleItems;
    sizeOfChart = pie.heightCoefficient;
    isNames = pie.ringNum == 1;
    userChosenRadiusForText = pie.startingRadiusOfText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: Colors.transparent),
        ),
        height: sizeOfChart,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: _RotatingPieChartInternal(
            bounds: bounds,
            items: items,
            textStyle: pie.textStyle,
            textHeightCoefficient: userChosenRadiusForText,
            accellerationFactor: accellerationFactor,
            isNames: isNames,
            userChosenRadiusForText: userChosenRadiusForText,
            pie: pie,
          ),
        ),
      ),
    );
  }
}

class _RotatingPieChartInternal extends StatefulWidget {
  final double accellerationFactor;
  final List<PieChartItem> items;
  final double textHeightCoefficient;
  final List<double> bounds;
  final bool isNames;
  final double userChosenRadiusForText;
  final TextStyle textStyle;
  final PieInfo pie;

  const _RotatingPieChartInternal({
    Key? key,
    this.accellerationFactor = 1.0,
    required this.items,
    required this.textHeightCoefficient,
    required this.bounds,
    required this.isNames,
    required this.userChosenRadiusForText,
    required this.textStyle,
    required this.pie,
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
  late TextStyle textStyle;
  late double textHeightCoefficient;
  late double userChosenRadius;
  late PieChartItemToText toText;
  late PieInfo pie;

  List<String> finalStrings = List.empty(growable: true);
  List<String> finalStringsOverflow = List.empty(growable: true);

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
    userChosenRadius = widget.textHeightCoefficient;
    numChunks = widget.items.length;
    CHUNK_SIZE = (2 * pi / numChunks);
    textStyle = widget.textStyle;
    textHeightCoefficient = widget.textHeightCoefficient;
    toText = (item, _) => TextPainter(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: textStyle,
            text: item.name,
          ),
          textDirection: TextDirection.ltr,
        );
    pie = widget.pie;
    if (!isNames) setUpFinalStrings();
    super.initState();
  }

  double radiansToDegrees(double radians) {
    return radians * 180 / pi;
  }

  final _testPainter = TextPainter(textDirection: TextDirection.ltr);
  double getAlphaForSpecificLetter(String letter) {
    _testPainter.text = TextSpan(
      text: letter,
      style: widget.textStyle,
    );
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
    double total = ((chunkAlpha - totalWordAlpha) / WIDTH_OF_SMALLEST_LETTER)
        .ceilToDouble();
    return total;
  }

  String addPaddingToInitialPhrase(
      String initialPhrase, double leftPaddingNum, double rightPaddingNum) {
    String leftPadding = "";
    String rightPadding = "";
    for (int j = 0; j < leftPaddingNum; j++) {
      leftPadding += "~~";
    }
    String finalString = "$leftPadding$initialPhrase$rightPadding";
    if (pie.ringNum == 3) {
      finalString = "~~~$finalString";
      if (rightPaddingNum >= 3) {
        for (int i = 0;
            i < rightPaddingNum + (7 - widget.items.length);
            i += 2) {
          finalString = "~~$finalString";
        }
      }
    } else if (pie.ringNum == 2) {
      finalString = "~$finalString";
      if (rightPaddingNum >= 2 && leftPaddingNum <= 2) {
        for (int i = 0; i < rightPaddingNum; i += 3) {
          finalString = "~$finalString";
        }
      }
    }
    if (!Global.isPhone) finalString = "~$finalString";
    if (Global.isHighPixelRatio) finalString = "~$finalString";

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
      if (chunkAlpha[i] <= 2) {
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

    //5. Decide on what length of strings should be allowed for the user to type in
    // we would then cap that amount when the user is inputting the amount
  }

  List<String> splitPhraseForOverflow(String phraseToSplit) {
    List<String> phraseParts = List.empty(growable: true);
    int i = (phraseToSplit.length / 2).floor();
    const int numLettersToCheck = 5;
    for (int j = 0; j < numLettersToCheck; j++) {
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
      for (int j = 0; j < numLettersToCheck; j++) {
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
        getTotalPhraseAlpha(phraseParts[0].trim()), CHUNK_SIZE));
    numTotalPaddingElements.add(getTotalPaddingAsIntegerIncrements(
        getTotalPhraseAlpha(phraseParts[1].trim()), CHUNK_SIZE));

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
        phraseParts[0].trim(), leftPaddingNums[0], rightPaddingNums[0]);
    phraseParts[1] = addPaddingToInitialPhrase(
        phraseParts[1].trim(), leftPaddingNums[1] - 1, rightPaddingNums[1]);
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
          RotationEndSimulation(
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
                        textStyle,
                        _animation.value + 1.57079632679,
                        finalStrings,
                        finalStringsOverflow,
                        numChunks,
                      )
                    : PieTextPainter(
                        items: this.widget.items,
                        rotation: _animation.value,
                        toText: toText = (item, _) => TextPainter(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: textStyle,
                                text: item.name,
                              ),
                              textDirection: TextDirection.ltr,
                            ),
                        textRadiusCoefficient: textHeightCoefficient,
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
