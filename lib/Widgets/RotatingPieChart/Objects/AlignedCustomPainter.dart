import 'package:flutter/material.dart';

abstract class AlignedCustomPainterInterface extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // for convenience I'm doing all the drawing in a 100x100 square then moving it rather than worrying
    // about the actual size.
    // Also, using a 100x100 square for convenience so we can hardcode values.
    FittedSizes fittedSizes =
        applyBoxFit(BoxFit.contain, const Size(100.0, 100.0), size);
    var dest = fittedSizes.destination;
    canvas.translate(
        (size.width - dest.width) / 2 + 1, (size.height - dest.height) / 2 + 1);
    canvas.scale((dest.width - 2) / 100.0);
    alignedPaint(canvas, const Size(100.0, 100.0));
  }

  void alignedPaint(Canvas canvas, Size size);
}
