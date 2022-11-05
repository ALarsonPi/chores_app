import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class ArcTextPainter extends CustomPainter {
  ArcTextPainter({
    required this.userChosenRadius,
    required this.textStyle,
    required this.initialAngle,
    required this.listOfChunkPhrases,
    required this.forwardPhraseAlpha,
    required this.listOfReverseChunkPhrases,
    required this.listOfCenterValues,
    required this.reversePhraseAlpha,
    required this.numChunks,
    required this.spaceBetweenLines,
    required this.isRotating,
    required this.shouldHaveFluidTransition,
    required this.shouldFlipText,
    required this.shouldCenterText,
    this.isRing3 = false,
    this.flipStatusArray = const [false],
  });

  List<double> listOfCenterValues = List.empty(growable: true);
  List<bool> flipStatusArray;
  List<bool> lastFlippedStatus = List.empty(growable: true);
  List<List<double>> forwardPhraseAlpha;
  List<List<double>> reversePhraseAlpha;

  bool isRing3;
  bool isRotating;
  bool shouldHaveFluidTransition;
  bool shouldFlipText;
  bool shouldCenterText;
  bool shouldReverse = false;

  double userChosenRadius;
  double initialAngle;
  double spaceBetweenLines;

  final TextStyle textStyle;
  final _textPainter = TextPainter(textDirection: TextDirection.ltr);
  final List<List<String>> listOfChunkPhrases;
  final List<List<String>> listOfReverseChunkPhrases;
  final int numChunks;

  late double actualRadius = userChosenRadius;
  late Canvas pieCanvas;

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  double radiansToDegrees(double radians) {
    return radians * 180 / pi;
  }

  @override
  void paint(Canvas canvas, Size size) {
    assert(listOfChunkPhrases.isNotEmpty);
    assert(listOfReverseChunkPhrases.isNotEmpty);

    _paintChunks(
      listOfChunkPhrases,
      forwardPhraseAlpha,
      listOfReverseChunkPhrases,
      reversePhraseAlpha,
      numChunks,
      spaceBetweenLines,
      canvas,
      size,
    );
  }

  setActualTextRadius(int numPhrasesInChunk, bool shouldReverse) {
    if (shouldCenterText) {
      // This is still a bit hard coded, but better than it was
      if (shouldReverse) actualRadius += 10;

      if (shouldReverse && numPhrasesInChunk == 2) {
        actualRadius += spaceBetweenLines / 2;
      } else if (shouldReverse && numPhrasesInChunk == 3) {
        actualRadius += spaceBetweenLines;
      } else if (shouldReverse) {
        actualRadius += numPhrasesInChunk + (spaceBetweenLines / 2);
      } else if (!shouldReverse && numPhrasesInChunk == 2) {
        actualRadius += spaceBetweenLines / 2;
      }
    }
  }

  void _paintChunk(
    List<String> phrases,
    List<double> phraseAlpha,
    double spaceBetweenLines,
    Canvas canvas,
    Size size,
    bool shouldReversePrint,
  ) {
    setActualTextRadius(phrases.length, shouldReversePrint && shouldFlipText);
    for (int i = 0; i < phrases.length; i++) {
      double currPhraseAlpha = phraseAlpha[i];
      double singleChunkAngle = (2 * pi / numChunks);
      double halfPhraseAlpha = currPhraseAlpha / 2;

      canvas.save();

      if (shouldReversePrint && shouldFlipText) {
        canvas.translate(size.width / 2, size.height / 2);
        canvas.translate(0, actualRadius);

        double singleChunkSize = 360 / numChunks;
        double initialAngleInDegrees = (radiansToDegrees(initialAngle) % 360);
        double numChunksAwayFromZero =
            initialAngleInDegrees.ceilToDouble() / singleChunkSize;

        double amountToRotate = ((numChunks - numChunksAwayFromZero) *
            degreesToRadians(singleChunkSize));

        //If odd num, rotate slightly more
        if (numChunks == 2) {
          amountToRotate += singleChunkAngle;
        } else if (numChunks == 3) {
          amountToRotate += (singleChunkAngle / 2) - singleChunkAngle;
        } else if (numChunks == 5) {
          amountToRotate += singleChunkAngle / 2;
        } else if (numChunks == 6) {
          amountToRotate += singleChunkAngle;
        } else if (numChunks == 7) {
          amountToRotate += singleChunkAngle + (singleChunkAngle / 2);
        } else if (numChunks == 8) {
          amountToRotate += 2 * singleChunkAngle;
        }

        double newInitialAngle = amountToRotate +
            singleChunkAngle + //To offset by single chunk
            (singleChunkAngle / 2) - //to start at mid-point
            halfPhraseAlpha; //to offset by phrase length

        _reversePaintPhrase(
            canvas, size, newInitialAngle, actualRadius, phrases[i]);
      } else {
        canvas.translate(size.width / 2, size.height / 2 - actualRadius);

        double newInitialAngle = initialAngle +
            //singleChunkAngle + // no need to offset by a single chunk
            (singleChunkAngle / 2) - //to start at mid-point
            halfPhraseAlpha; //to offset by phrase length

        _paintPhrase(
            canvas, size, newInitialAngle, actualRadius, phrases[i], false);
      }
      actualRadius -= spaceBetweenLines;
      canvas.restore();
    }
    actualRadius = userChosenRadius;
  }

  bool shouldReversePrint(double initialAngle) {
    double degreesOfChunk =
        (radiansToDegrees(initialAngle) % 360).ceilToDouble();
    double middleAngle = degreesOfChunk + ((360 / numChunks) / 2);
    // Angle for Arc text starts at 90 degrees
    return (middleAngle >= 92 && middleAngle <= 272);
  }

  void paintFluidPhrases(
    Canvas canvas,
    Size size,
    List<List<String>> listOfChunks,
    List<List<double>> forwardAlpha,
    List<List<String>> listOfReverseChunks,
    List<List<double>> reverseAlpha,
  ) {
    for (int i = 0; i < numChunks; i++) {
      canvas.save();
      shouldReverse = shouldReversePrint(initialAngle);
      List<String> phraseListToUse = List.empty(growable: true);
      List<double> alphaListToUse = List.empty(growable: true);
      if (shouldReverse) {
        phraseListToUse = listOfReverseChunks[i].reversed.toList();
        alphaListToUse = reverseAlpha[i];
      } else {
        phraseListToUse = listOfChunks[i];
        alphaListToUse = forwardAlpha[i];
      }
      _paintChunk(phraseListToUse, alphaListToUse, spaceBetweenLines, canvas,
          size, shouldReverse);
      canvas.restore();
      incrementAngleByChunkSize();
    }
  }

  void setCurrentFlipStatus() {
    double initialAngleAtStart = initialAngle;
    for (int i = 0; i < numChunks; i++) {
      shouldReverse = shouldReversePrint(initialAngle);

      if (shouldReverse) {
        flipStatusArray[i] = true;
      } else {
        flipStatusArray[i] = false;
      }

      incrementAngleByChunkSize();
    }
    initialAngle = initialAngleAtStart;
  }

  void _paintChunks(
    List<List<String>> listOfChunks,
    List<List<double>> forwardAlpha,
    List<List<String>> listOfReverseChunks,
    List<List<double>> reverseAlpha,
    int numChunks,
    double spaceBetweenLines,
    Canvas canvas,
    Size size,
  ) {
    assert(listOfChunks.isNotEmpty);
    assert(forwardAlpha.isNotEmpty);
    assert(listOfReverseChunkPhrases.isNotEmpty);
    assert(reverseAlpha.isNotEmpty);

    if (shouldFlipText && shouldHaveFluidTransition) {
      paintFluidPhrases(canvas, size, listOfChunks, forwardAlpha,
          listOfReverseChunks, reverseAlpha);
      return;
    }

    if (shouldFlipText && !isRotating) {
      setCurrentFlipStatus();
    }

    lastFlippedStatus.clear();
    lastFlippedStatus.addAll(flipStatusArray);

    for (int i = 0; i < numChunks; i++) {
      canvas.save();
      shouldReverse = lastFlippedStatus[i];
      List<String> phraseListToUse = List.empty(growable: true);
      List<double> alphaListToUse = List.empty(growable: true);
      if (shouldReverse) {
        phraseListToUse = listOfReverseChunks[i].reversed.toList();
        alphaListToUse = reverseAlpha[i];
      } else {
        phraseListToUse = listOfChunks[i];
        alphaListToUse = forwardAlpha[i];
      }
      _paintChunk(phraseListToUse, alphaListToUse, spaceBetweenLines, canvas,
          size, shouldReverse);
      canvas.restore();
      incrementAngleByChunkSize();
    }
  }

  void incrementAngleByChunkSize() {
    initialAngle += (2 * pi / numChunks);
  }

  void _reversePaintPhrase(Canvas canvas, Size size, double initialAngle,
      double radiusToUse, String phraseToPrint) {
    if (initialAngle != 0) {
      double d = 2 * radiusToUse * sin(initialAngle / 2);
      final rotationAngle = _calculateRotationAngle(0, initialAngle);
      canvas.rotate((shouldReverse) ? -rotationAngle : rotationAngle);
      canvas.translate(d, 0);
    }
    double angle = initialAngle;

    for (int i = 0; i < phraseToPrint.length; i++) {
      angle = _drawLetter(
          canvas, phraseToPrint[i], angle, radiusToUse, shouldReverse);
    }
  }

  void _paintPhrase(Canvas canvas, Size size, double initialAngle,
      double radiusToUse, String phraseToPrint, bool shouldReversePhrasePrint) {
    if (initialAngle != 0) {
      final d = 2 * radiusToUse * sin(initialAngle / 2);
      final rotationAngle = _calculateRotationAngle(0, initialAngle);
      canvas.rotate(rotationAngle);
      canvas.translate(d, 0);
    }
    double angle = initialAngle;
    for (int i = 0; i < phraseToPrint.length; i++) {
      angle = _drawLetter(canvas, phraseToPrint[i], angle, radiusToUse,
          shouldReversePhrasePrint);
    }
  }

  double _drawLetter(Canvas canvas, String letter, double prevAngle,
      double actualRadius, bool shouldDrawReverse) {
    bool shouldSkip = letter == "~";
    _textPainter.text =
        TextSpan(text: shouldSkip ? 'i' : letter, style: textStyle);
    _textPainter.layout(
      minWidth: 0,
      maxWidth: double.maxFinite,
    );
    double d = _textPainter.width;
    final double alpha = 2 * asin(d / (2 * actualRadius));
    final newAngle = _calculateRotationAngle(prevAngle, alpha);
    canvas.rotate((shouldDrawReverse) ? -newAngle : newAngle);
    if (!shouldSkip) {
      _textPainter.paint(canvas, Offset(0, -_textPainter.height));
    }
    canvas.translate(d, 0);
    return alpha;
  }

  double _calculateRotationAngle(double prevAngle, double alpha) =>
      (alpha + prevAngle) / 2;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
