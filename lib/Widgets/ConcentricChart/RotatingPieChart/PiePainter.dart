import 'dart:math';
import 'package:chore_app/Widgets/ConcentricChart/RotatingPieChart/Objects/AlignedCustomPainter.dart';
import 'package:chore_app/Widgets/ConcentricChart/RotatingPieChart/Objects/PieChartItem.dart';
import 'package:flutter/material.dart';

class PieChartPainter extends AlignedCustomPainterInterface {
  final List<PieChartItem> items;
  final double total;
  final double rotation;
  final Color linesColor;

  PieChartPainter(
      {this.rotation = 0, required this.items, required this.linesColor})
      : total = items.fold(0.0, (total, el) => total + el.val);

  @override
  void alignedPaint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;

    double soFar = rotation;
    Paint outlinePaint = Paint()
      //The chart circle border color
      ..color = linesColor
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
