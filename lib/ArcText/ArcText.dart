// import 'dart:math';

// import 'package:flutter/material.dart';

// class ArcText extends StatelessWidget {
//   final double radius;
//   final String text;
//   final double startAngle;
//   final TextStyle textStyle;
//   const ArcText(
//       {super.key,
//       required this.radius,
//       required this.text,
//       required this.textStyle,
//       required this.startAngle});

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: _Painter(radius, text, textStyle, startAngle),
//     );
//   }
// }

// class _Painter extends CustomPainter {
//   final double radius;
//   final String text;
//   final double initialAngle;
//   final TextStyle textStyle;
//   _Painter(this.radius, this.text, this.textStyle, this.initialAngle);

//   final TextPainter _textPainter =
//       TextPainter(textDirection: TextDirection.ltr);

//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.translate(size.width / 2, size.height / 2);
//     if (initialAngle != 0) {
//       final d = 2 * radius * sin(initialAngle / 2);
//       final rotationAngle = _calculateRotationAngle(0, initialAngle);
//       canvas.rotate(rotationAngle);
//       canvas.translate(d, 0);
//     }
//     canvas.drawCircle(
//         Offset.zero, radius, Paint()..style = PaintingStyle.stroke);
//     canvas.translate(0, -radius);
//     double angle = 0;
//     for (int i = 0; i < text.length; i++) {
//       angle = _drawLetter(canvas, text[i], angle);
//     }
//   }

//   double _drawLetter(Canvas canvas, String letter, double prevAng) {
//     _textPainter.text = TextSpan(text: letter, style: textStyle);
//     _textPainter.layout(minWidth: 0, maxWidth: double.maxFinite);
//     final double d = _textPainter.width;
//     final double alpha = 2 * asin(d / (2 * radius));
//     final newAngle = _calculateRotationAngle(prevAng, alpha);
//     canvas.rotate(newAngle);
//     _textPainter.paint(canvas, Offset(0, -_textPainter.height));
//     canvas.translate(d, 0);
//     return alpha;
//   }

//   double _calculateRotationAngle(double prevAngle, double alpha) {
//     //Average of alpha and prevAngle, but what is alpha?
//     return (alpha + prevAngle) / 2;
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ArcText extends StatelessWidget {
  const ArcText({
    super.key,
    required this.radius,
    required this.text,
    required this.textStyle,
    required this.startAngle,
  });
  final double radius;
  final String text;
  final double startAngle;
  final TextStyle textStyle;

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _Painter(
          radius,
          text,
          textStyle,
          initialAngle: degreesToRadians(startAngle),
        ),
      );
}

class _Painter extends CustomPainter {
  _Painter(this.radius, this.text, this.textStyle, {this.initialAngle = 0});
  final num radius;
  final String text;
  final double initialAngle;
  final TextStyle textStyle;
  final _textPainter = TextPainter(textDirection: TextDirection.ltr);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2 - radius);
    if (initialAngle != 0) {
      final d = 2 * radius * sin(initialAngle / 2);
      final rotationAngle = _calculateRotationAngle(0, initialAngle);
      canvas.rotate(rotationAngle);
      canvas.translate(d, 0);
    }
    double angle = initialAngle;
    for (int i = 0; i < text.length; i++) {
      angle = _drawLetter(canvas, text[i], angle);
    }
  }

  double _drawLetter(Canvas canvas, String letter, double prevAngle) {
    _textPainter.text = TextSpan(text: letter, style: textStyle);
    _textPainter.layout(
      minWidth: 0,
      maxWidth: double.maxFinite,
    );
    final double d = _textPainter.width;
    final double alpha = 2 * asin(d / (2 * radius));
    final newAngle = _calculateRotationAngle(prevAngle, alpha);
    canvas.rotate(newAngle);
    _textPainter.paint(canvas, Offset(0, -_textPainter.height));
    canvas.translate(d, 0);
    return alpha;
  }

  double _calculateRotationAngle(double prevAngle, double alpha) =>
      (alpha + prevAngle) / 2;
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
