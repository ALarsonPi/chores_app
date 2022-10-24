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
    required this.reversePhraseAlpha,
    required this.numChunks,
    required this.spaceBetweenLines,
    required this.isRotating,
    required this.shouldHaveFluidTransition,
    this.isRing3 = false,
    this.flipStatusArray = const [false],
  });

  bool isRing3;

  bool shouldHaveFluidTransition;
  List<bool> flipStatusArray;
  List<bool> lastFlippedStatus = List.empty(growable: true);

  bool isRotating;
  double userChosenRadius;
  double initialAngle;
  double spaceBetweenLines;
  final TextStyle textStyle;
  final _textPainter = TextPainter(textDirection: TextDirection.ltr);
  final List<List<String>> listOfChunkPhrases;
  final List<List<String>> listOfReverseChunkPhrases;
  final int numChunks;

  List<List<double>> forwardPhraseAlpha;
  List<List<double>> reversePhraseAlpha;

  late double actualRadius = userChosenRadius;
  late Canvas pieCanvas;

  bool shouldReverse = false;

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  double radiansToDegrees(double radians) {
    return radians * 180 / pi;
  }

  @override
  void paint(Canvas canvas, Size size) {
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

  setActualRadius(int numPhrasesInChunk, bool shouldReverse) {
    if (isRing3) actualRadius += 3 * spaceBetweenLines / 4;

    // this part is a VERY imprecise art. Thought should be put into
    // finding a way to actaully center text in the ring (vertically)
    // regardless of how many chunks it has

    // If we just have one line, try to center it
    if (numPhrasesInChunk == 1) {
      actualRadius +=
          (shouldReverse) ? -spaceBetweenLines / 6 : -3 * spaceBetweenLines / 4;
    } else if (numPhrasesInChunk == 2) {
      actualRadius +=
          (shouldReverse) ? spaceBetweenLines / 6 : -2 * spaceBetweenLines / 4;
    } else if (numPhrasesInChunk == 3) {
      actualRadius +=
          (shouldReverse) ? spaceBetweenLines : spaceBetweenLines / 8;
      if ((Device.get().isAndroid && Device.get().isPhone)) {
        actualRadius +=
            (shouldReverse) ? -spaceBetweenLines / 2 : -spaceBetweenLines / 4;
      }
    } else {
      actualRadius +=
          (shouldReverse) ? spaceBetweenLines * (numPhrasesInChunk - 3) : 0;
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
    setActualRadius(phrases.length, shouldReversePrint);
    for (int i = 0; i < phrases.length; i++) {
      double currPhraseAlpha = phraseAlpha[i];
      double singleChunkAngle = (2 * pi / numChunks);
      double halfPhraseAlpha = currPhraseAlpha / 2;

      canvas.save();

      if (shouldReversePrint) {
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
    if (shouldHaveFluidTransition) {
      paintFluidPhrases(canvas, size, listOfChunks, forwardAlpha,
          listOfReverseChunks, reverseAlpha);
      return;
    }

    if (!isRotating) {
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
