import 'dart:math';
import 'package:chore_app/Widgets/ConcentricChart/RotatingPieChart/Objects/PieInfo.dart';
import 'package:chore_app/Widgets/ConcentricChart/RotatingPieChart/PiePainter.dart';
import 'package:chore_app/Widgets/ConcentricChart/RotatingPieChart/TextPainters/ArcText.dart';
import 'package:chore_app/Widgets/ConcentricChart/RotatingPieChart/Objects/PieChartItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'Objects/TextItem.dart';
import 'RotationEndSimulation.dart';
import 'TextPainters/NameTextPainter.dart';

/// Pie Chart that is rotatable by the User
/// and has text displayed around it's edges if desired
class RotatingPieChart extends StatelessWidget {
  /// Rate at whcih the acceleration / decceleration occurs when the user
  /// spins the chart
  final double accellerationFactor;

  /// The Segments of the PieChart
  late List<PieChartItem> items;

  /// The width of the chart. Will constrain the stack to this size
  late double sizeOfChart;

  /// Is this the innermost circle? If so, then we'll use a different type of
  /// text painter
  late bool isCircle1;

  final List<double> bounds;
  double spaceBetweenLines;
  int overflowLineLimit;
  double chunkOverflowLimitProportion;
  bool isOuterRing;

  /// The Pie which holds info about this circle
  final PieInfo pie;

  /// The color of the border lines around the circle / between the segments
  final Color linesColor;

  /// Constructor which takes these parameters and calculates the spaceBetweenLines
  /// based on what was sent in as well as whether the device is a phone
  /// and if the device has a pixelAspectRatio above 2
  RotatingPieChart({
    super.key,
    this.accellerationFactor = 1.0,
    required this.bounds,
    required this.pie,
    required this.spaceBetweenLines,
    required this.overflowLineLimit,
    required this.linesColor,
    required this.chunkOverflowLimitProportion,
    required this.isOuterRing,
  }) {
    items = pie.items;
    sizeOfChart = pie.width;
    isCircle1 = pie.ringNum == 1;
    if (!Device.get().isPhone) spaceBetweenLines += 20;
    if (Device.devicePixelRatio > 2) spaceBetweenLines += 2;
  }

  /// Creates a Container which holds the inner pie chart, the color of the container
  /// is transparent so the corners don't show and the shape of the decoration is
  /// a circle to help with that same issue
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: Colors.transparent),
        ),
        width: sizeOfChart,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: _RotatingPieChartInternal(
            bounds: bounds,
            items: items,
            textStyle: pie.textStyle,
            textHeightCoefficient: pie.textProportion,
            accellerationFactor: accellerationFactor,
            isCircle1: isCircle1,
            spaceBetweenLines: spaceBetweenLines,
            overflowLineLimit: overflowLineLimit,
            overflowLimitProportion: chunkOverflowLimitProportion,
            linesColor: linesColor,
            pie: pie,
            isOuterRing: isOuterRing,
          ),
        ),
      ),
    );
  }
}

/// Internal State for the rotating pie chart
class _RotatingPieChartInternal extends StatefulWidget {
  final double accellerationFactor;
  final List<PieChartItem> items;
  final double textHeightCoefficient;
  final List<double> bounds;
  final bool isCircle1;
  final TextStyle textStyle;
  final double spaceBetweenLines;
  final PieInfo pie;
  final int overflowLineLimit;
  final double overflowLimitProportion;

  final Color linesColor;
  final bool isOuterRing;

  const _RotatingPieChartInternal({
    Key? key,
    this.accellerationFactor = 1.0,
    required this.items,
    required this.textHeightCoefficient,
    required this.bounds,
    required this.isCircle1,
    required this.textStyle,
    required this.spaceBetweenLines,
    required this.pie,
    required this.isOuterRing,
    required this.overflowLineLimit,
    required this.linesColor,
    required this.overflowLimitProportion,
  }) : super(key: key);

  @override
  _RotatingPieChartInternalState createState() =>
      _RotatingPieChartInternalState();
}

/// The Internal State of the Rotating Pie Chart
class _RotatingPieChartInternalState extends State<_RotatingPieChartInternal>
    with SingleTickerProviderStateMixin {
  /// The controller of the animation of this chart
  late AnimationController _controller;

  /// The animation that shows when starting up the app. Spins the circle twice
  /// around then stops in the correct position
  late Animation<double> _animation;

  late bool isCircle1;
  late TextStyle textStyle;
  late double textHeightCoefficient;
  late PieChartItemToText toText;
  late double spaceBetweenLines;
  late PieInfo pie;
  late bool shouldHaveFluidTransition;
  late bool shouldCenterTextVertically;
  late int overflowLineLimit;
  late List<double> ringBorders;
  late bool isOuterRing;

  /// Phrases as built for the upper quadrants
  List<List<String>> chunkPhraseList = List.empty(growable: true);

  /// Phrases as built for the lower quadrants
  List<List<String>> reversePhraseChunkList = List.empty(growable: true);

  /// List of Alpha (length in pixels) of the phrases for the upper quadrants
  List<List<double>> forwardAlphaList = List.empty(growable: true);

  /// List of Alpha (length in pixels) of the phrases for the lower quadrants
  List<List<double>> reverseAlphaList = List.empty(growable: true);

  /// List to keep track of which elements should be flipped
  List<bool> flipStatusArray = List.empty(growable: true);

  /// Number of chunks the chart has (for every text item provided, there should
  /// be one chunk / segment)
  late int numChunks;

  /// All variables are initialized, animation is prepared and performed
  /// Call to [setUpPhraseChunks] is made if it applies
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _animation = Tween(begin: 0.0, end: 2.0 * pi).animate(_controller);
    _controller.animateTo(2 * pi, duration: const Duration(seconds: 5));
    isCircle1 = widget.isCircle1;
    numChunks = widget.items.length;
    textStyle = widget.textStyle;
    textHeightCoefficient = widget.textHeightCoefficient;
    overflowLineLimit = widget.overflowLineLimit;
    isOuterRing = widget.isOuterRing;
    toText = (item, _) => TextPainter(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: textStyle,
            text: item.name,
          ),
          textDirection: TextDirection.ltr,
        );
    pie = widget.pie;
    ringBorders = pie.ringBorders;

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

  /// Gets the alpha for a specific letter based on it's size and fontstyle
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

  /// Gets the alpha for a phrase using the [getAlphaForSpecificLetter] method
  double getTotalPhraseAlpha(String word, double desiredRadius) {
    double sum = 0;
    for (var currLetter in word.characters) {
      sum += getAlphaForSpecificLetter(currLetter, desiredRadius);
    }
    return sum;
  }

  /// Checks to see if the phrase should overflow into the next line
  /// Should overflow if the alphaDifference (chunkAlpha - actualAlphaOfPhrase)
  /// is less than the limit provided by the overflowLimitProportion
  bool checkIfShouldOverflow(double alphaDifference) {
    return alphaDifference <= widget.overflowLimitProportion;
  }

  /// For forward phrases, this function splits the phrase into chunks that
  /// all fit into the segment. Returns a list of those split phrases for the chunks
  List<String> getOverflowedPhrasePartsForChunk(String fullPhrase) {
    List<String> phrasesToReturn = List.empty(growable: true);
    String currPhrase = fullPhrase;
    double radiusToMeasureAgainst = getMiddleVerticalRadius();

    double phraseAlpha =
        getTotalPhraseAlpha(currPhrase, radiusToMeasureAgainst);
    double chunkDifference = (2 * pi / numChunks) - phraseAlpha;

    bool isOverflowing = checkIfShouldOverflow(chunkDifference);
    int numLines = 1;
    if (isOverflowing) {
      // If it's one word, don't split
      if ((currPhrase.split(" ").length == 1)) {
        // Unless it has a char breakpoint
        if (!phraseHasCharacterBreakpoint(currPhrase)) {
          phrasesToReturn.add(currPhrase);
          return phrasesToReturn;
        }
      }
      while (isOverflowing && numLines <= widget.overflowLineLimit) {
        phraseAlpha = getTotalPhraseAlpha(currPhrase, radiusToMeasureAgainst);
        chunkDifference = (2 * pi / numChunks) - phraseAlpha;

        radiusToMeasureAgainst -= spaceBetweenLines;

        if (checkIfShouldOverflow(chunkDifference) &&
            numLines <= widget.overflowLineLimit) {
          List<String> splitPhraseParts = splitPhraseForOverflow(currPhrase);
          currPhrase = splitPhraseParts.last;

          // Check for special case where we're finishing up and need to add
          // the last line due to the overflow limit
          phraseAlpha = getTotalPhraseAlpha(currPhrase, radiusToMeasureAgainst);
          chunkDifference = (2 * pi / numChunks) - phraseAlpha;
          if (numLines == widget.overflowLineLimit) {
            if (splitPhraseParts.first.characters.last == "-") {
              splitPhraseParts.first = splitPhraseParts.first
                  .substring(0, splitPhraseParts.first.length - 1);
            }
            splitPhraseParts.first += splitPhraseParts.last;
            phrasesToReturn.add(splitPhraseParts.first);
          } else {
            phrasesToReturn.add(splitPhraseParts.first);
          }
        } else {
          isOverflowing = false;
          phrasesToReturn.add(currPhrase);
        }
        numLines++;
      }
    } else {
      phrasesToReturn.add(fullPhrase);
    }

    return phrasesToReturn;
  }

  /// For reverse phrases (those which will be used in the lower quadrants),
  /// this function splits the phrase into chunks that
  /// all fit into the segment. Returns a list of those split phrases for the chunks
  List<String> getOverflowedPhrasePartsForReverseChunk(
      String fullPhrase, int numLines) {
    List<String> phrasesToReturn = List.empty(growable: true);

    //Reverse string so that the split actually makes
    //sense when we reverse everything back
    String currPhrase = fullPhrase.split('').reversed.join();

    double radiusToMeasureAgainst = getMiddleVerticalRadius() -
        (spaceBetweenLines * numLines) +
        (3 * spaceBetweenLines / 2);

    double phraseAlpha =
        getTotalPhraseAlpha(currPhrase, radiusToMeasureAgainst);
    double chunkDifference = (2 * pi / numChunks) - phraseAlpha;

    bool isOverflowing = checkIfShouldOverflow(chunkDifference);
    if (isOverflowing) {
      // If it's one word, don't split
      if ((currPhrase.split(" ").length == 1)) {
        // Unless it has a char breakpoint
        if (!phraseHasCharacterBreakpoint(currPhrase)) {
          phrasesToReturn.add(currPhrase);
          return phrasesToReturn;
        }
      }
      int numLines = 1;
      while (isOverflowing && numLines <= widget.overflowLineLimit) {
        phraseAlpha = getTotalPhraseAlpha(currPhrase, radiusToMeasureAgainst);
        chunkDifference = (2 * pi / numChunks) - phraseAlpha;

        radiusToMeasureAgainst += spaceBetweenLines;

        if (checkIfShouldOverflow(chunkDifference) &&
            numLines != widget.overflowLineLimit) {
          List<String> splitPhraseParts = splitPhraseForOverflow(currPhrase);
          currPhrase = splitPhraseParts.last;

          // Check for special case where we're finishing up and need to add
          // the last line due to the overflow limit
          phraseAlpha = getTotalPhraseAlpha(currPhrase, radiusToMeasureAgainst);
          chunkDifference = (2 * pi / numChunks) - phraseAlpha;
          if (numLines == widget.overflowLineLimit) {
            if (splitPhraseParts.first.characters.last == "-") {
              splitPhraseParts.first = splitPhraseParts.first
                  .substring(0, splitPhraseParts.first.length - 1);
            }
            splitPhraseParts.first += splitPhraseParts.last;
            phrasesToReturn.add(splitPhraseParts.first);
          } else {
            phrasesToReturn.add(splitPhraseParts.first);
          }
        } else {
          isOverflowing = false;
          phrasesToReturn.add(currPhrase);
        }
        numLines++;
      }
    } else {
      // If there's only one (no overflow)
      phrasesToReturn.add(fullPhrase.split('').reversed.join());
    }

    for (int i = 0; i < phrasesToReturn.length; i++) {
      phrasesToReturn[i] = phrasesToReturn[i].split('').reversed.join();
    }

    return phrasesToReturn.reversed.toList();
  }

  /// Master method that gets overflowed chunks and adds them to the appropriate lists
  void setUpPhraseChunkAndAddToLists(String fullPhrase) {
    List<String> forwardPhrases = getOverflowedPhrasePartsForChunk(fullPhrase);
    List<String> reversePhrases = getOverflowedPhrasePartsForReverseChunk(
        fullPhrase, forwardPhrases.length);
    assert(forwardPhrases.isNotEmpty);
    assert(reversePhrases.isNotEmpty);
    chunkPhraseList.add(forwardPhrases);
    reversePhraseChunkList.add(reversePhrases);
  }

  /// Creates the alpha list for forward phrases
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

  /// Creates the alpha list for lower quadrant phrases
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

  /// Sets up all the lists - phrases and alpha lists for upper and lower quadrants
  setUpPhraseChunks() {
    assert(numChunks > 0);
    for (int i = 0; i < numChunks; i++) {
      setUpPhraseChunkAndAddToLists(widget.items[i].name);
    }
    fillAlphaLists();
  }

  /// Fills the alpha lists for each chunk of phrases
  fillAlphaLists() {
    for (List<String> phrasesInAChunk in chunkPhraseList) {
      List<double> alphaList =
          createAlphaListForward(phrasesInAChunk, getMiddleVerticalRadius());
      forwardAlphaList.add(alphaList);
    }
    for (List<String> reversePhrasesInAChunk in reversePhraseChunkList) {
      List<double> alphaListReverse = createAlphaListReverse(
          reversePhrasesInAChunk, getMiddleVerticalRadius());
      reverseAlphaList.add(alphaListReverse);
    }
  }

  /// Splits a phrase if overflow is necessary.
  /// Finds where the string needs to split to no longer be overflowing.
  /// Then, tries to find a space ' ' a certain number of letters before
  /// but if it can't find a space, will just add a hyphen and split from there
  List<String> splitPhraseForOverflow(String phraseToSplit) {
    List<String> phraseParts = List.empty(growable: true);
    int numLettersToCheck = 6;

    bool shouldOverflow = true;
    int index = phraseToSplit.length;
    String subString = phraseToSplit;
    for (; index > 1; index--) {
      subString = phraseToSplit.substring(0, index);
      double phraseAlpha =
          getTotalPhraseAlpha(subString, getMiddleVerticalRadius());
      double alphaDifference = (2 * pi / numChunks) - phraseAlpha;
      shouldOverflow = checkIfShouldOverflow(alphaDifference);
      if (!shouldOverflow) {
        break;
      }
    }

    String spaceSubString = subString;
    int index2 = index;
    bool foundSpace = false;
    for (int checkerIndex = 0;
        checkerIndex <= numLettersToCheck;
        checkerIndex++) {
      index2 = subString.length - checkerIndex;
      spaceSubString = subString.substring(0, index2);
      if (index2 == 0) {
        break;
      }
      assert(spaceSubString.isNotEmpty);

      if (hasCharacterBreakpoint(spaceSubString.characters.last)) {
        foundSpace = true;
        break;
      }
    }

    if (foundSpace) {
      // Minus 1 to account for the space
      phraseParts.add(phraseToSplit.substring(0, index2));
      phraseParts.add(phraseToSplit.substring(index2));
    } else {
      // Minus 1 to account for the hyphen
      // ignore: prefer_interpolation_to_compose_strings
      phraseParts.add(phraseToSplit.substring(0, index - 1) + "-");
      phraseParts.add(phraseToSplit.substring(index - 1));
    }

    return phraseParts;
  }

  bool hasCharacterBreakpoint(var currChar) {
    List acceptableBreakpoints = [" ", "\t", "\n", "-", ",", ".", "_", "/"];
    bool foundBreakpoint = false;
    for (var breakpoint in acceptableBreakpoints) {
      if (currChar == breakpoint) {
        foundBreakpoint = true;
      }
    }
    return foundBreakpoint;
  }

  bool phraseHasCharacterBreakpoint(String currPhrase) {
    bool hasBreakpointChar = false;
    for (var currChar in currPhrase.toString().characters) {
      if (hasCharacterBreakpoint(currChar)) {
        hasBreakpointChar = true;
      }
    }
    return hasBreakpointChar;
  }

  double getMiddleVerticalRadius() {
    return (pie.ringBorders[1] + pie.ringBorders[0]) / 2;
  }

  /// Closes the controller / disploses of it
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// The dirction last dragged by the user
  late Offset lastDirection;

  /// Gets the last direction to set [lastDirection]
  Offset getDirection(Offset globalPosition) {
    RenderBox? box = context.findRenderObject() as RenderBox?;
    Offset? offset = box?.globalToLocal(globalPosition);
    Offset center =
        Offset(context.size!.width / 2.0, context.size!.height / 2.0);
    return offset! - center;
  }

  /// Variable to record when the chart is being rotated and when it's still
  bool isNotBeingRotated = true;

  /// Sets the [isNotBeingRotated] variable and updates the chart's state
  void startStopWheelRotation() {
    setState(() {
      isNotBeingRotated = !isNotBeingRotated;
    });
  }

  CircularTextDirection getCurrTextDirection(double angleInDegrees) {
    angleInDegrees = angleInDegrees % 360;
    return (angleInDegrees >= 180 && angleInDegrees <= 270 ||
            angleInDegrees <= 0 && angleInDegrees >= -90 ||
            angleInDegrees >= 270 && angleInDegrees <= 360)
        ? CircularTextDirection.clockwise
        : CircularTextDirection.anticlockwise;
  }

  List<Text> makeListOfText(int currIndex, bool isForward) {
    List<Text> listOfTexts = List.empty(growable: true);

    List<String> textListToUse = List.empty(growable: true);

    if (isForward) {
      textListToUse.addAll(chunkPhraseList[currIndex]);
    } else {
      textListToUse.addAll(reversePhraseChunkList[currIndex].reversed.toList());
    }

    for (int j = 0; j < textListToUse.length; j++) {
      assert(textListToUse.isNotEmpty);

      listOfTexts.add(
        Text(
          textListToUse[j],
          style: TextStyle(
            fontSize: textStyle.fontSize,
            color: textStyle.color,
            fontWeight: textStyle.fontWeight,
          ),
        ),
      );
    }

    return listOfTexts;
  }

  List<TextItem> getTextItemList() {
    List<TextItem> listOfItems = List.empty(growable: true);

    for (int i = 0; i < numChunks; i++) {
      List<Text> forwardChunkLines = makeListOfText(i, true);
      List<Text> reverseChunkLines = makeListOfText(i, false);

      double chunkDiff = (360 / numChunks);
      double currStartAngle = ((chunkDiff * i) - (chunkDiff / 2)) +
          radiansToDegrees(_animation.value);
      listOfItems.add(
        TextItem(
          forwardTexts: forwardChunkLines,
          reverseTexts: reverseChunkLines,
          space: 4.75,
          startAngle: currStartAngle,
          startAngleAlignment: StartAngleAlignment.center,
          direction: getCurrTextDirection(currStartAngle),
        ),
      );
    }

    return listOfItems;
  }

  /// Using a gesture detector, the chart detects when someone starts spinning
  /// the chart. The chart is animated with a [RotationEndSimulation] which
  /// just applies friction until the wheel stops. When it finally stops, it
  /// clicks into the correct position it's closest to.
  /// Uses three different CustomPainters -
  /// [ArcTextPainter] for the two outermost rings
  /// [PieTextPainter] for the inner most ring
  /// and [PieChartPainter] to actaully draw out the background color of the charts
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
        startStopWheelRotation(),
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
        startStopWheelRotation();
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
                    ? // HM which to use
                    // CircularTextPainter(
                    //     textDirection: TextDirection.ltr,
                    //     radius: pie.textProportion,
                    //     ringNum: pie.ringNum,
                    //     spaceBetweenLines: spaceBetweenLines,
                    //     isOuterRing: isOuterRing,
                    //     middleVerticalRadius: getMiddleVerticalRadius(),
                    //     textItems: [
                    //       ...getTextItemList(),
                    //     ],
                    //   )
                    ArcTextPainter(
                        userChosenRadius: getMiddleVerticalRadius(),
                        textStyle: textStyle,
                        initialAngle: _animation.value + 1.57079632679,
                        listOfChunkPhrases: chunkPhraseList,
                        forwardPhraseAlpha: forwardAlphaList,
                        listOfReverseChunkPhrases: reversePhraseChunkList,
                        reversePhraseAlpha: reverseAlphaList,
                        numChunks: numChunks,
                        spaceBetweenLines: spaceBetweenLines + 10,
                        isRing3: this.widget.pie.ringNum == 3,
                        isRotating: !isNotBeingRotated,
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
            linesColor: widget.linesColor,
          ),
        ),
      ),
    );
  }
}