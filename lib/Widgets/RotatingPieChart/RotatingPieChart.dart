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
  late bool isCircle1;
  late double userChosenRadiusForText;

  final List<double> bounds;
  double spaceBetweenLines;
  bool shouldHaveFluidTransition;

  final PieInfo pie;

  RotatingPieChart({
    super.key,
    this.accellerationFactor = 1.0,
    required this.bounds,
    required this.pie,
    required this.spaceBetweenLines,
    required this.shouldHaveFluidTransition,
  }) {
    items = pie.textAndAngleItems;
    sizeOfChart = pie.heightCoefficient;
    isCircle1 = pie.ringNum == 1;
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
            isCircle1: isCircle1,
            userChosenRadiusForText: userChosenRadiusForText,
            spaceBetweenLines: spaceBetweenLines,
            shouldHaveFluidTransition: shouldHaveFluidTransition,
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
  final bool isCircle1;
  final double userChosenRadiusForText;
  final TextStyle textStyle;
  final double spaceBetweenLines;
  final PieInfo pie;
  final bool shouldHaveFluidTransition;

  const _RotatingPieChartInternal({
    Key? key,
    this.accellerationFactor = 1.0,
    required this.items,
    required this.textHeightCoefficient,
    required this.bounds,
    required this.isCircle1,
    required this.userChosenRadiusForText,
    required this.textStyle,
    required this.spaceBetweenLines,
    required this.shouldHaveFluidTransition,
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
  late bool isCircle1;
  late TextStyle textStyle;
  late double textHeightCoefficient;
  late double userChosenRadius;
  late PieChartItemToText toText;
  late double spaceBetweenLines;
  late PieInfo pie;
  late bool shouldHaveFluidTransition;

  List<List<String>> chunkPhraseList = List.empty(growable: true);
  List<List<String>> reversePhraseChunkList = List.empty(growable: true);

  List<List<double>> forwardAlphaList = List.empty(growable: true);
  List<List<double>> reverseAlphaList = List.empty(growable: true);

  List<bool> flipStatusArray = List.empty(growable: true);

  late int numChunks;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _animation = Tween(begin: 0.0, end: 2.0 * pi).animate(_controller);
    _controller.animateTo(2 * pi, duration: const Duration(seconds: 5));
    isCircle1 = widget.isCircle1;
    userChosenRadius = widget.textHeightCoefficient;
    numChunks = widget.items.length;
    textStyle = widget.textStyle;
    textHeightCoefficient = widget.textHeightCoefficient;
    shouldHaveFluidTransition = widget.shouldHaveFluidTransition;
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
    for (int i = 0; i < numChunks; i++) {
      flipStatusArray.add(false);
    }
    if (!isCircle1) setUpPhraseChunks();
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

  bool checkIfShouldOverflow(double alphaDifference) {
    return alphaDifference <= 0.35;
  }

  List<String> getOverflowedPhrasePartsForChunk(String fullPhrase) {
    List<String> phrasesToReturn = List.empty(growable: true);
    String currPhrase = fullPhrase;
    double radiusToMeasureAgainst = userChosenRadius;

    double phraseAlpha =
        getTotalPhraseAlpha(currPhrase, radiusToMeasureAgainst);
    double chunkDifference = (2 * pi / numChunks) - phraseAlpha;

    bool isOverflowing = checkIfShouldOverflow(chunkDifference);
    if (isOverflowing) {
      while (isOverflowing) {
        phraseAlpha = getTotalPhraseAlpha(currPhrase, radiusToMeasureAgainst);
        chunkDifference = (2 * pi / numChunks) - phraseAlpha;

        radiusToMeasureAgainst -= spaceBetweenLines;

        if (checkIfShouldOverflow(chunkDifference)) {
          List<String> splitPhraseParts = splitPhraseForOverflow(currPhrase);
          phrasesToReturn.add(splitPhraseParts.first);
          currPhrase = splitPhraseParts.last;
        } else {
          isOverflowing = false;
          phrasesToReturn.add(currPhrase);
        }
      }
    } else {
      phrasesToReturn.add(fullPhrase);
    }

    return phrasesToReturn;
  }

  List<String> getOverflowedPhrasePartsForReverseChunk(
      String fullPhrase, int numLines) {
    List<String> phrasesToReturn = List.empty(growable: true);

    //Reverse string so that the split actually makes
    //sense when we reverse everything back
    String currPhrase = fullPhrase.split('').reversed.join();

    double radiusToMeasureAgainst = userChosenRadius -
        (spaceBetweenLines * numLines) +
        (spaceBetweenLines / 2);

    double phraseAlpha =
        getTotalPhraseAlpha(currPhrase, radiusToMeasureAgainst);
    double chunkDifference = (2 * pi / numChunks) - phraseAlpha;

    bool isOverflowing = checkIfShouldOverflow(chunkDifference);
    int index = 0;
    if (isOverflowing) {
      while (isOverflowing) {
        phraseAlpha = getTotalPhraseAlpha(currPhrase, radiusToMeasureAgainst);
        chunkDifference = (2 * pi / numChunks) - phraseAlpha;

        radiusToMeasureAgainst += spaceBetweenLines;

        if (checkIfShouldOverflow(chunkDifference)) {
          List<String> splitPhraseParts = splitPhraseForOverflow(currPhrase);
          phrasesToReturn.add(splitPhraseParts.first);
          currPhrase = splitPhraseParts.last;
        } else {
          isOverflowing = false;
          phrasesToReturn.add(currPhrase);
        }
        index++;
      }
    } else {
      phrasesToReturn.add(fullPhrase.split('').reversed.join());
    }
    for (int i = 0; i < phrasesToReturn.length; i++) {
      phrasesToReturn[i] = phrasesToReturn[i].split('').reversed.join();
    }
    return phrasesToReturn.reversed.toList();
  }

  void setUpPhraseChunkAndAddToLists(String fullPhrase) {
    List<String> forwardPhrases = getOverflowedPhrasePartsForChunk(fullPhrase);
    List<String> reversePhrases = getOverflowedPhrasePartsForReverseChunk(
        fullPhrase, forwardPhrases.length);
    chunkPhraseList.add(forwardPhrases);
    reversePhraseChunkList.add(reversePhrases);
  }

  List<double> createAlphaListForward(
      List<String> phrases, double initialRadius) {
    List<double> alphaList = List.empty(growable: true);
    double currRadius = initialRadius;
    for (String phrase in phrases) {
      alphaList.add(getTotalPhraseAlpha(phrase, currRadius));
      currRadius -= spaceBetweenLines;
    }
    return alphaList;
  }

  List<double> createAlphaListReverse(
      List<String> reversePhrases, double initialRadius) {
    List<double> alphaList = List.empty(growable: true);
    double currRadius = initialRadius;
    for (String phrase in reversePhrases.reversed) {
      alphaList.add(getTotalPhraseAlpha(phrase, currRadius));
      currRadius -= spaceBetweenLines;
    }
    return alphaList;
  }

  setUpPhraseChunks() async {
    for (int i = 0; i < numChunks; i++) {
      setUpPhraseChunkAndAddToLists(widget.items[i].name);
    }
    fillAlphaLists();
  }

  fillAlphaLists() {
    for (List<String> phrasesInAChunk in chunkPhraseList) {
      List<double> alphaList =
          createAlphaListForward(phrasesInAChunk, userChosenRadius);
      forwardAlphaList.add(alphaList);
    }
    for (List<String> reversePhrasesInAChunk in reversePhraseChunkList) {
      List<double> alphaListReverse =
          createAlphaListReverse(reversePhrasesInAChunk, userChosenRadius);
      reverseAlphaList.add(alphaListReverse);
    }
  }

  List<String> splitPhraseForOverflow(String phraseToSplit) {
    List<String> phraseParts = List.empty(growable: true);
    int i = (phraseToSplit.length / 2).floor();
    int numLettersToCheck = 5;
    numLettersToCheck = min(i, numLettersToCheck);
    if (phraseParts.isEmpty) {
      for (int j = 0; j < numLettersToCheck; j++) {
        if (phraseToSplit[i] == " " ||
            phraseToSplit[i] == "\t" ||
            phraseToSplit[i] == "\n") {
          phraseParts.add(phraseToSplit.substring(0, i).trim());
          phraseParts.add(phraseToSplit.substring(i).trim());
        }
        i++;
      }
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

  bool isNotBeingRotated = true;
  void isNotBeingRotatedFunction() {
    setState(() {
      isNotBeingRotated = !isNotBeingRotated;
    });
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
      onPanStart: (details) => {
        isNotBeingRotatedFunction(),
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
        isNotBeingRotatedFunction();
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
                painter: (!isCircle1)
                    ? ArcTextPainter(
                        userChosenRadius: userChosenRadius,
                        textStyle: textStyle,
                        initialAngle: _animation.value + 1.57079632679,
                        listOfChunkPhrases: chunkPhraseList,
                        forwardPhraseAlpha: forwardAlphaList,
                        listOfReverseChunkPhrases: reversePhraseChunkList,
                        reversePhraseAlpha: reverseAlphaList,
                        numChunks: numChunks,
                        spaceBetweenLines: spaceBetweenLines,
                        isRing3: this.widget.pie.ringNum == 3,
                        isRotating: !isNotBeingRotated,
                        shouldHaveFluidTransition: shouldHaveFluidTransition,
                        flipStatusArray: flipStatusArray,
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
