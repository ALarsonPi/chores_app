import 'dart:math';

import 'package:flutter/material.dart';

import '../Objects/AlignedCustomPainter.dart';
import '../Objects/PieChartItem.dart';

class PieTextPainter extends AlignedCustomPainterInterface {
  final List<PieChartItem> items;
  final double total;
  final double rotation;
  final List<double> middles;
  final PieChartItemToText toText;
  final double textRadiusCoefficient;

  PieTextPainter._(
    this.items,
    this.total,
    this.rotation,
    this.middles,
    this.toText,
    this.textRadiusCoefficient,
  );

  factory PieTextPainter({
    double rotation = 0.0,
    required List<PieChartItem> items,
    required PieChartItemToText toText,
    required double textRadiusCoefficient,
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
      textRadiusCoefficient,
    );
  }

  @override
  void alignedPaint(Canvas canvas, Size size) {
    for (int i = 0; i < items.length; ++i) {
      var middleRad = middles[i];
      var item = items[i];
      var rad = size.width / 2;

      var middleX = rad + rad * textRadiusCoefficient * cos(middleRad);
      var middleY = rad + rad * textRadiusCoefficient * sin(middleRad);

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
