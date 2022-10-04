import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ArcTextPainter extends CustomPainter {
  ArcTextPainter(
    this.userChosenRadius,
    this.text,
    this.textStyle,
    this.initialAngle,
    this.finalStrings,
  );
  final double userChosenRadius;
  final String text;
  final double initialAngle;
  final TextStyle textStyle;
  final _textPainter = TextPainter(textDirection: TextDirection.ltr);
  final List<String> finalStrings;

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  double radiansToDegrees(double radians) {
    return radians * 180 / pi;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2 - userChosenRadius);
    if (initialAngle != 0) {
      final d = 2 * userChosenRadius * sin(initialAngle / 2);
      final rotationAngle = _calculateRotationAngle(0, initialAngle);
      canvas.rotate(rotationAngle);
      canvas.translate(d, 0);
    }
    double angle = initialAngle;

    for (var currTextItem in finalStrings) {
      for (int i = 0; i < currTextItem.length; i++) {
        angle = _drawLetter(canvas, currTextItem[i], angle);
      }
    }
  }

  double _drawLetter(Canvas canvas, String letter, double prevAngle) {
    _textPainter.text = TextSpan(text: letter, style: textStyle);
    _textPainter.layout(
      minWidth: 0,
      maxWidth: double.maxFinite,
    );
    final double d = _textPainter.width;
    final double alpha = 2 * asin(d / (2 * userChosenRadius));
    final newAngle = _calculateRotationAngle(prevAngle, alpha);
    canvas.rotate(newAngle);
    _textPainter.paint(canvas, Offset(0, -_textPainter.height));
    canvas.translate(d, 0);
    return alpha;
  }

  double _dontDrawLetter(Canvas canvas, double prevAngle) {
    _textPainter.text = TextSpan(text: "l", style: textStyle);
    _textPainter.layout(
      minWidth: 0,
      maxWidth: double.maxFinite,
    );
    final double d = _textPainter.width;
    final double alpha = 2 * asin(d / (2 * userChosenRadius));
    final newAngle = _calculateRotationAngle(prevAngle, alpha);
    canvas.rotate(newAngle);
    canvas.translate(d, 0);
    return alpha;
  }

  double _calculateRotationAngle(double prevAngle, double alpha) =>
      (alpha + prevAngle) / 2;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
