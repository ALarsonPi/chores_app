import 'dart:math';

import 'package:flutter/material.dart';

import '../Objects/TextItem.dart';

class CircularTextPainter extends CustomPainter {
  final List<TextItem> textItems;

  final CircularTextPosition position;
  final Paint backgroundPaint;
  final TextDirection textDirection;

  double radius = 0.0;
  bool isOuterRing;
  int ringNum;
  double middleVerticalRadius;
  double spaceBetweenLines;

  CircularTextPainter({
    required this.textItems,
    required this.radius,
    required this.ringNum,
    required this.middleVerticalRadius,
    required this.spaceBetweenLines,
    this.isOuterRing = false,
    this.position = CircularTextPosition.inside,
    Paint? backgroundPaint,
    required this.textDirection,
  }) : this.backgroundPaint =
            backgroundPaint ?? (Paint()..color = Colors.transparent);

  TextPainter getTextPainterForLetter(var letter, TextStyle? textStyle) {
    return TextPainter(
        text: TextSpan(text: letter, style: textStyle),
        textDirection: textDirection)
      ..layout();
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < textItems.length; i++) {
      drawChunkAllLines(canvas, size, i);
    }
  }

  void drawChunkAllLines(Canvas canvas, Size size, int indexOfCurrItem) {
    bool isForward = (textItems[indexOfCurrItem].direction ==
        CircularTextDirection.clockwise);
    TextItem currItem = textItems[indexOfCurrItem];

    // Text Item is a whole chunk
    if (isOuterRing) {
      currItem.space -= 2;
    }

    List<Text> currTextToUse =
        (isForward) ? currItem.forwardTexts : currItem.reverseTexts;

    // Calculate total height
    double letterHeight = getTextPainterForLetter(
            currTextToUse[0].data.toString()[0], currTextToUse[0].style)
        .height;
    double totalHeightForThisChunk = currTextToUse.length * letterHeight +
        (currTextToUse.length - 1) * spaceBetweenLines;

    for (int j = 0; j < currTextToUse.length; j++) {
      drawPhraseLine(canvas, size, currTextToUse[j], currItem, letterHeight,
          totalHeightForThisChunk, j, currTextToUse, isForward);
    }

    if (isOuterRing) {
      currItem.space += 2;
    }
  }

  void drawPhraseLine(
      Canvas canvas,
      Size size,
      Text phraseLineInTextWidget,
      TextItem textItem,
      double totalHeightForThisChunk,
      double heightOfALetter,
      int lineNum,
      List<Text> listToUse,
      bool isForward) {
    canvas.save();
    double offsetByLine = (lineNum == 0)
        ? 0
        : (lineNum * heightOfALetter + (lineNum - 1) * spaceBetweenLines) /
            (listToUse.length + 1);
    // If no overflow, no adjustment of spacing, just center
    if (listToUse.length == 1) {
      totalHeightForThisChunk = 0;
    }

    radius =
        middleVerticalRadius + (totalHeightForThisChunk / 2) - offsetByLine;
    canvas.translate(size.width / 2, size.height / 2);

    List<TextPainter> _charPainters = [];
    for (var char in phraseLineInTextWidget.data!.split("")) {
      TextPainter charPainter =
          getTextPainterForLetter(char, phraseLineInTextWidget.style);
      _charPainters.add(charPainter);
    }

    if (isForward) {
      _paintTextClockwise(canvas, size, textItem, _charPainters);
    } else {
      _paintTextAntiClockwise(canvas, size, textItem, _charPainters);
    }

    canvas.restore();
  }

  void _paintTextClockwise(
    Canvas canvas,
    Size size,
    TextItem textItem,
    List<TextPainter> _charPainters,
  ) {
    bool hasStrokeStyle = backgroundPaint.style == PaintingStyle.stroke &&
        backgroundPaint.strokeWidth > 0.0;
    double angleShift = _calculateAngleShift(textItem, _charPainters.length);
    canvas.rotate((textItem.startAngle + 90 - angleShift) * pi / 180);
    for (int i = 0; i < _charPainters.length; i++) {
      final tp = _charPainters[i];
      final x = -tp.width / 2;
      final y = position == CircularTextPosition.outside
          ? (-radius - tp.height) -
              (hasStrokeStyle ? backgroundPaint.strokeWidth / 2 : 0.0)
          : -radius - (hasStrokeStyle ? tp.height / 2 : 0.0);

      tp.paint(canvas, Offset(x, y));
      canvas.rotate(textItem.space * pi / 180);
    }
  }

  void _paintTextAntiClockwise(Canvas canvas, Size size, TextItem textItem,
      List<TextPainter> _charPainters) {
    bool hasStrokeStyle = backgroundPaint.style == PaintingStyle.stroke &&
        backgroundPaint.strokeWidth > 0.0;

    double angleShift = _calculateAngleShift(textItem, _charPainters.length);
    canvas.rotate((textItem.startAngle - 90 + angleShift) * pi / 180);
    for (int i = 0; i < _charPainters.length; i++) {
      final tp = _charPainters[i];
      final x = -tp.width / 2;
      final y = position == CircularTextPosition.outside
          ? radius + (hasStrokeStyle ? backgroundPaint.strokeWidth / 2 : 0.0)
          : (radius - tp.height) + (hasStrokeStyle ? tp.height / 2 : 0.0);

      tp.paint(canvas, Offset(x, y));
      canvas.rotate(-textItem.space * pi / 180);
    }
  }

  double _calculateAngleShift(TextItem textItem, int textLength) {
    double angleShift = -1;
    switch (textItem.startAngleAlignment) {
      case StartAngleAlignment.start:
        angleShift = 0;
        break;
      case StartAngleAlignment.center:
        int halfItemsLength = textLength ~/ 2;
        if (textLength % 2 == 0) {
          angleShift =
              ((halfItemsLength - 1) * textItem.space) + (textItem.space / 2);
        } else {
          angleShift = (halfItemsLength * textItem.space);
        }
        break;
      case StartAngleAlignment.end:
        angleShift = (textLength - 1) * textItem.space;
        break;
    }
    return angleShift;
  }

  @override
  bool shouldRepaint(CircularTextPainter oldDelegate) {
    bool isTextItemsChanged() {
      bool isChanged = false;
      for (int i = 0; i < textItems.length; i++) {
        if (textItems[i].isChanged(oldDelegate.textItems[i])) {
          isChanged = true;
          break;
        }
      }
      return isChanged;
    }

    bool isBackgroundPaintChanged() {
      return oldDelegate.backgroundPaint.color != backgroundPaint.color ||
          oldDelegate.backgroundPaint.style != backgroundPaint.style ||
          oldDelegate.backgroundPaint.strokeWidth !=
              backgroundPaint.strokeWidth;
    }

    return isTextItemsChanged() ||
        oldDelegate.position != position ||
        oldDelegate.textDirection != textDirection ||
        isBackgroundPaintChanged();
  }
}
