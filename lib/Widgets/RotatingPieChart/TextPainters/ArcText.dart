import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../Global.dart';

class ArcTextPainter extends CustomPainter {
  ArcTextPainter(
    this.userChosenRadius,
    this.textStyle,
    this.initialAngle,
    this.finalStrings,
    this.finalStringsOverflow,
    this.numChunks,
  );
  double userChosenRadius;
  double initialAngle;
  final TextStyle textStyle;
  final _textPainter = TextPainter(textDirection: TextDirection.ltr);
  final List<String> finalStrings;
  final List<String> finalStringsOverflow;
  final int numChunks;

  late Canvas pieCanvas;

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double spaceBetweenLines = 20;
    if (!Global.isPhone) spaceBetweenLines += 25;
    if (Global.isHighPixelRatio) spaceBetweenLines += 5;

    _paintPhrases(
        finalStrings, finalStringsOverflow, canvas, size, spaceBetweenLines);
    userChosenRadius -= spaceBetweenLines;
    _paintPhrases(finalStringsOverflow, null, canvas, size, spaceBetweenLines);
    userChosenRadius += spaceBetweenLines;
  }

  void _paintPhrases(List<String> phrases, List<String>? overflowPhrases,
      Canvas canvas, Size size, double spaceBetweenLines) {
    for (int i = 0; i < phrases.length; i++) {
      canvas.save();
      bool shouldCenter = overflowPhrases != null && overflowPhrases[i].isEmpty;
      if (shouldCenter) {
        userChosenRadius -= spaceBetweenLines / 2;
      }
      canvas.translate(size.width / 2, size.height / 2 - userChosenRadius);
      canvas.save();
      _paintPhrase(canvas, size, initialAngle, userChosenRadius, phrases[i]);
      canvas.restore();
      initialAngle += (2 * pi / numChunks);
      canvas.restore();
      if (shouldCenter) {
        userChosenRadius += spaceBetweenLines / 2;
      }
    }
  }

  void _paintPhrase(
    Canvas canvas,
    Size size,
    double initialAngle,
    double radiusToUse,
    String phraseToPrint,
  ) {
    if (initialAngle != 0) {
      final d = 2 * radiusToUse * sin(initialAngle / 2);
      final rotationAngle = _calculateRotationAngle(0, initialAngle);
      canvas.rotate(rotationAngle);
      canvas.translate(d, 0);
    }
    double angle = initialAngle;

    for (int i = 0; i < phraseToPrint.length; i++) {
      angle = _drawLetter(canvas, phraseToPrint[i], angle);
    }
  }

  double _drawLetter(Canvas canvas, String letter, double prevAngle) {
    bool shouldSkip = letter == "~";
    _textPainter.text =
        TextSpan(text: shouldSkip ? 'i' : letter, style: textStyle);
    _textPainter.layout(
      minWidth: 0,
      maxWidth: double.maxFinite,
    );
    final double d = _textPainter.width;
    final double alpha = 2 * asin(d / (2 * userChosenRadius));
    final newAngle = _calculateRotationAngle(prevAngle, alpha);
    canvas.rotate(newAngle);
    if (!shouldSkip) {
      _textPainter.paint(canvas, Offset(0, -_textPainter.height));
    }
    canvas.translate(d, 0);
    return alpha;
  }

  double _calculateRotationAngle(double prevAngle, double alpha) =>
      (alpha + prevAngle) / 2;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
