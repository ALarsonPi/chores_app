import 'dart:math';
import 'package:chore_app/Widgets/RotatingPieChart/Objects/PieInfo.dart';
import 'package:chore_app/Widgets/RotatingPieChart/TextPainters/ArcText.dart';
import 'package:chore_app/Widgets/RotatingPieChart/Objects/PieChartItem.dart';
import 'package:chore_app/Widgets/RotatingPieChart/PiePainter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'RotationEndSimulation.dart';
import 'TextPainters/NameTextPainter.dart';

class RotatingPieChart extends StatelessWidget {
  final double accellerationFactor;
  late List<PieChartItem> items;
  late double sizeOfChart;
  final List<double> bounds;
  late bool isNames;
  late double userChosenRadiusForText;
  late double spaceBetweenLines;
  final PieInfo pie;

  RotatingPieChart({
    super.key,
    this.accellerationFactor = 1.0,
    required this.bounds,
    required this.pie,
    required this.spaceBetweenLines,
  }) {
    items = pie.textAndAngleItems;
    sizeOfChart = pie.heightCoefficient;
    isNames = pie.ringNum == 1;
    userChosenRadiusForText = pie.startingRadiusOfText;
    if (!Device.get().isPhone) spaceBetweenLines += 25;
    if (Device.devicePixelRatio > 2) spaceBetweenLines += 5;
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
            spaceBetweenLines: spaceBetweenLines,
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
  final double spaceBetweenLines;
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
    required this.spaceBetweenLines,
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
  late double spaceBetweenLines;
  late PieInfo pie;

  List<List<String>> chunkPhraseList = List.empty(growable: true);
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
    spaceBetweenLines = widget.spaceBetweenLines;
    if (!isNames) setUpPhraseChunks();
    super.initState();
  }

  double radiansToDegrees(double radians) {
    return radians * 180 / pi;
  }

  final _testPainter = TextPainter(textDirection: TextDirection.ltr);
  double getAlphaForSpecificLetter(String letter, double desiredRadius) {
    _testPainter.text = TextSpan(
      text: letter,
      style: widget.textStyle,
    );
    _testPainter.layout(
      minWidth: 0,
      maxWidth: double.maxFinite,
    );
    final double d = _testPainter.width;
    final double alpha = 2 * asin(d / (2 * desiredRadius));
    return alpha;
  }

  double getTotalPhraseAlpha(String word, double desiredRadius) {
    double sum = 0;
    for (var currLetter in word.characters) {
      sum += getAlphaForSpecificLetter(currLetter, desiredRadius);
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
    if (!Device.get().isPhone) finalString = "~$finalString";
    if (Device.devicePixelRatio > 2) finalString = "~$finalString";

    return finalString;
  }

  double getTotalPadding(String phrase, double desiredRadius) {
    double chunkAlpha = getTotalPhraseAlpha(phrase, desiredRadius);
    return getTotalPaddingAsIntegerIncrements(chunkAlpha, CHUNK_SIZE);
  }

  // This method is used while calculating overflow
  double getHalfOfTotalPaddingFor(String phrase) {
    double totalPadding = getTotalPadding(phrase, userChosenRadius);
    double halfOfTotalPadding = totalPadding / 2;
    return halfOfTotalPadding;
  }

  List<double> getLeftAndRightPadding(String phrase, double desiredRadius) {
    double totalPadding = getTotalPadding(phrase, desiredRadius);

    // Break padding into left and right, favoring left
    double remainder = totalPadding % 2;
    double halfOfTotalPadding = totalPadding / 2;

    double leftPaddingAmount = halfOfTotalPadding + remainder;
    double rightPaddingAmount = halfOfTotalPadding;

    List<double> paddings = List.empty(growable: true);
    paddings.add(leftPaddingAmount);
    paddings.add(rightPaddingAmount);

    return paddings;
  }

  List<String> getOverflowedPhrasePartsForChunk(String fullPhrase) {
    List<String> phrasesToReturn = List.empty(growable: true);
    String currPhrase = fullPhrase;
    double halfOfTotalPadding = getHalfOfTotalPaddingFor(currPhrase);
    const int MIN_PADDING_FOR_OVERFLOW = 2;
    bool isOverflowing = halfOfTotalPadding <= MIN_PADDING_FOR_OVERFLOW;

    // If it will overflow at least once
    // overflow as many times as is needed
    if (isOverflowing) {
      while (isOverflowing) {
        halfOfTotalPadding = getHalfOfTotalPaddingFor(currPhrase);
        List<String> splitPhraseParts = splitPhraseForOverflow(currPhrase);
        phrasesToReturn.add(splitPhraseParts.first);
        if (getHalfOfTotalPaddingFor(splitPhraseParts.last) <=
            MIN_PADDING_FOR_OVERFLOW) {
          currPhrase = splitPhraseParts.last;
        } else {
          isOverflowing = false;
          phrasesToReturn.add(splitPhraseParts.last);
        }
      }
    } else {
      phrasesToReturn.add(fullPhrase);
    }

    return phrasesToReturn;
  }

  List<String> setUpPhraseChunk(String fullPhrase) {
    List<String> unpaddedPhrases = getOverflowedPhrasePartsForChunk(fullPhrase);
    List<String> phrasesToReturn = List.empty(growable: true);

    double currRadius = userChosenRadius;

    // For every unpaddedPhrase, add padding
    for (String phrase in unpaddedPhrases) {
      List<double> paddings = getLeftAndRightPadding(phrase, currRadius);
      String paddedString =
          addPaddingToInitialPhrase(phrase, paddings.first, paddings.last);
      currRadius -= spaceBetweenLines / 2;
      phrasesToReturn.add(paddedString);
    }
    return phrasesToReturn;
  }

  setUpPhraseChunks() async {
    for (int i = 0; i < numChunks; i++) {
      List<String> chunkPhrases = setUpPhraseChunk(widget.items[i].name);
      chunkPhraseList.add(chunkPhrases);
    }
  }

  List<String> splitPhraseForOverflow(String phraseToSplit) {
    List<String> phraseParts = List.empty(growable: true);
    int i = (phraseToSplit.length / 2).floor();
    int numLettersToCheck = 5;
    numLettersToCheck = min(i, numLettersToCheck);
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
                        chunkPhraseList,
                        numChunks,
                        spaceBetweenLines,
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
