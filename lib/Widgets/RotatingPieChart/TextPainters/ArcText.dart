import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ArcTextPainter extends CustomPainter {
  ArcTextPainter(
    this.userChosenRadius,
    this.textStyle,
    this.initialAngle,
    this.listOfChunkPhrases,
    this.numChunks,
    this.spaceBetweenLines,
  );
  double userChosenRadius;
  double initialAngle;
  double spaceBetweenLines;
  final TextStyle textStyle;
  final _textPainter = TextPainter(textDirection: TextDirection.ltr);
  final List<List<String>> listOfChunkPhrases;
  final int numChunks;

  late double actualRadius = userChosenRadius;
  late Canvas pieCanvas;

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _paintChunks(
        listOfChunkPhrases, numChunks, spaceBetweenLines, canvas, size);
  }

  void _paintChunk(List<String> phrases, double spaceBetweenLines,
      Canvas canvas, Size size) {
    if (phrases.length == 1) {
      //We might consider changing this centering amount / allowing it to be customizable
      // or getting the next inner most circle's height and actually center the text between that
      // and the far edge of this circle
      actualRadius -= spaceBetweenLines / 2;
    }
    for (String phrase in phrases) {
      canvas.save();
      canvas.translate(size.width / 2, size.height / 2 - actualRadius);
      _paintPhrase(canvas, size, initialAngle, actualRadius, phrase);
      actualRadius -= spaceBetweenLines;
      canvas.restore();
    }
    actualRadius = userChosenRadius;
  }

  void _paintChunks(List<List<String>> listOfChunks, int numChunks,
      double spaceBetweenLines, Canvas canvas, Size size) {
    for (int i = 0; i < numChunks; i++) {
      canvas.save();
      _paintChunk(listOfChunks[i], spaceBetweenLines, canvas, size);
      canvas.restore();
      incrementAngleByChunkSize();
    }
  }

  void incrementAngleByChunkSize() {
    initialAngle += (2 * pi / numChunks);
  }

  void _paintPhrase(Canvas canvas, Size size, double initialAngle,
      double radiusToUse, String phraseToPrint) {
    if (initialAngle != 0) {
      final d = 2 * radiusToUse * sin(initialAngle / 2);
      final rotationAngle = _calculateRotationAngle(0, initialAngle);
      canvas.rotate(rotationAngle);
      canvas.translate(d, 0);
    }
    double angle = initialAngle;

    for (int i = 0; i < phraseToPrint.length; i++) {
      angle = _drawLetter(canvas, phraseToPrint[i], angle, radiusToUse);
    }
  }

  double _drawLetter(
      Canvas canvas, String letter, double prevAngle, double actualRadius) {
    bool shouldSkip = letter == "~";
    _textPainter.text =
        TextSpan(text: shouldSkip ? 'i' : letter, style: textStyle);
    _textPainter.layout(
      minWidth: 0,
      maxWidth: double.maxFinite,
    );
    final double d = _textPainter.width;
    final double alpha = 2 * asin(d / (2 * actualRadius));
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
