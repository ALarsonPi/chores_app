import 'dart:math';
import 'package:chore_app/RotatingPieChart/AlignedCustomPainter.dart';
import 'package:chore_app/RotatingPieChart/PieChartItem.dart';
import 'package:flutter/material.dart';

class PieChartPainter extends AlignedCustomPainterInterface {
  final List<PieChartItem> items;
  final double total;
  final double rotation;

  PieChartPainter({this.rotation = 0.0, required this.items})
      : total = items.fold(0.0, (total, el) => total + el.val);

  @override
  void alignedPaint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;

    double soFar = rotation;
    Paint outlinePaint = Paint()
      //The chart circle border color
      ..color = Colors.white
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < items.length; ++i) {
      PieChartItem item = items[i];
      double arcRad = item.val / total * 2 * pi;
      canvas.drawArc(rect, soFar, arcRad, true, Paint()..color = item.color);
      canvas.drawArc(rect, soFar, arcRad, true, outlinePaint);
      soFar += arcRad;
    }
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) {
    return oldDelegate.rotation != rotation || oldDelegate.items != items;
  }
}

class PieTextPainter extends AlignedCustomPainterInterface {
  final List<PieChartItem> items;
  final double total;
  final double rotation;
  final List<double> middles;
  final PieChartItemToText toText;
  static const double textDisplayCenter = 0.7;

  PieTextPainter._(
    this.items,
    this.total,
    this.rotation,
    this.middles,
    this.toText,
  );

  factory PieTextPainter({
    double rotation = 0.0,
    required List<PieChartItem> items,
    required PieChartItemToText toText,
  }) {
    double total = items.fold(0.0, (prev, el) => prev + el.val);
    var middles = (() {
      double soFar = rotation;
      return items.map((item) {
        double arcRad = item.val / total * 2 * pi;
        double middleRad = (soFar) + (arcRad / 2);
        soFar += arcRad;
        return middleRad;
      }).toList(growable: false);
    })();
    return PieTextPainter._(
      items,
      total,
      rotation,
      middles,
      toText,
    );
  }

  @override
  void alignedPaint(Canvas canvas, Size size) {
    for (int i = 0; i < items.length; ++i) {
      var middleRad = middles[i];
      var item = items[i];
      var rad = size.width / 2;

      var middleX = rad + rad * textDisplayCenter * cos(middleRad);
      var middleY = rad + rad * textDisplayCenter * sin(middleRad);

      TextPainter textPainter = toText(item, total)..layout();
      textPainter.paint(
          canvas,
          Offset(middleX - (textPainter.width / 2),
              middleY - (textPainter.height / 2)));
    }
  }

  @override
  bool shouldRepaint(PieTextPainter oldDelegate) {
    // note that just checking items != items might not be enough.
    return oldDelegate.rotation != rotation ||
        oldDelegate.items != items ||
        oldDelegate.toText != toText;
  }
}
