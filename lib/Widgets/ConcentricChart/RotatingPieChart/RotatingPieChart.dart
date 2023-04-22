import 'dart:math';

import 'package:chore_app/Widgets/ConcentricChart/RotatingPieChart/Objects/PieChartItem.dart';
import 'package:chore_app/Widgets/ConcentricChart/RotatingPieChart/Objects/PieInfo.dart';
import 'package:chore_app/Widgets/ConcentricChart/RotatingPieChart/PiePainter.dart';
import 'package:chore_app/Widgets/ConcentricChart/RotatingPieChart/Services/TextParsingService.dart';
import 'package:chore_app/Widgets/ConcentricChart/RotatingPieChart/TextPainters/ArcText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import 'Services/RotationService.dart';
import 'TextPainters/NameTextPainter.dart';

// ignore: must_be_immutable
class RotatingPieChart extends StatefulWidget {
  final double accellerationFactor;
  late List<PieChartItem> items;
  final Function hasChangedPosition;
  late double sizeOfChart;
  final List<double> bounds;
  double spaceBetweenLines;
  int overflowLineLimit;
  double chunkOverflowLimitProportion;
  bool isOuterRing;
  final PieInfo pie;
  final Color linesColor;
  final bool shouldIgnoreTouch;

  RotatingPieChart({
    super.key,
    this.accellerationFactor = 1.0,
    required this.bounds,
    required this.pie,
    required this.spaceBetweenLines,
    required this.overflowLineLimit,
    required this.linesColor,
    required this.chunkOverflowLimitProportion,
    required this.isOuterRing,
    required this.hasChangedPosition,
    this.shouldIgnoreTouch = false,
  }) {
    items = pie.items;
    sizeOfChart = pie.width;
    if (!Device.get().isPhone) spaceBetweenLines += 20;
    if (Device.devicePixelRatio > 2) spaceBetweenLines += 2;
  }

  @override
  State<StatefulWidget> createState() {
    return RotatingPieChartState();
  }
}

class RotatingPieChartState extends State<RotatingPieChart>
    with SingleTickerProviderStateMixin {
  RotatingPieChartState();

  List<bool> flipStatusArray = List.empty(growable: true);
  late AnimationController _controller;
  late Animation<double> _animation;
  late TextParsingService textParsingService;
  late RotationService rotationService;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _animation = Tween(begin: 0.0, end: 2.0 * pi).animate(_controller);
    _controller.animateTo(widget.pie.currAngle,
        duration: const Duration(seconds: 5));
    flipStatusArray.clear();
    for (int i = 0; i < widget.pie.items.length; i++) {
      flipStatusArray.add(false);
    }
    textParsingService = TextParsingService(
      widget.pie.items.length,
      widget.spaceBetweenLines,
      widget.overflowLineLimit,
      widget.pie.ringBorders[0],
      widget.pie.ringBorders[1],
      widget.chunkOverflowLimitProportion,
      widget.pie.textStyle,
    );
    textParsingService.setItems(widget.pie.items);
    rotationService = RotationService(const Offset(0, 0));
    rotationService.setLastAngle(widget.pie.currAngle);
    textParsingService.clearAllTextLists();
    if (widget.pie.ringNum != 1) {
      textParsingService.setUpPhraseChunks(
          widget.pie.items.length, widget.pie.items);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  /// Closes the controller / disploses of it
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Variable to record when the chart is being rotated and when it's still
  bool isNotBeingRotated = true;
  double currentPosition = 0;
  double positionBeforeRotation = 0;
  double positionAfterRotation = 1;

  void startWheelRotation() {
    isNotBeingRotated = false;
    positionBeforeRotation = _controller.value;
    // setState(() {});/
  }

  void stopWheelRotation() {
    isNotBeingRotated = true;
    positionAfterRotation = _controller.value;
    // setState(() {});
  }

  void onRotationEnd() {
    stopWheelRotation();

    if (positionBeforeRotation != positionAfterRotation) {
      widget.hasChangedPosition(widget.pie.ringNum, _controller.value);
    }
  }

  handleChangesByOtherUsers() {
    if (textParsingService.numChunks != widget.pie.items.length) {
      debugPrint("Num items changed");

      textParsingService.setNumChunks(widget.pie.items.length);
    }
    if (!(widget.pie.ringNum == 1)) {
      // debugPrint("Text changed");
      textParsingService.setUpPhraseChunks(
          widget.pie.items.length, widget.pie.items);
      textParsingService.setItems(widget.pie.items);
    }
    if (widget.pie.currAngle != rotationService.getLastAngle()) {
      debugPrint("Angle changed");
      rotationService.setLastAngle(widget.pie.currAngle);

      setState(() {
        _controller.animateTo(rotationService.getLastAngle(),
            duration: const Duration(seconds: 1));
        // _controller.value = rotationService.getLastAngle();
        // debugPrint(_controller.value.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    handleChangesByOtherUsers();
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: Colors.transparent),
        ),
        width: widget.pie.width,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: IgnorePointer(
            ignoring: widget.shouldIgnoreTouch,
            child: GestureDetector(
              onPanDown: (details) {
                rotationService.setDirection(rotationService.getDirection(
                    details.globalPosition, context));
              },
              onPanUpdate: (details) {
                rotationService.getLastDirectionPanned(
                    details, context, _controller);
              },
              onPanStart: (details) => {
                startWheelRotation(),
              },
              onPanEnd: (details) {
                rotationService.animateEndPanning(
                  details,
                  widget.accellerationFactor,
                  _controller,
                  widget.bounds,
                  onRotationEnd,
                );
              },
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, circle) {
                  return Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Transform.rotate(
                        angle: _animation.value,
                        child: circle,
                      ),
                      CustomPaint(
                        painter: (!(widget.pie.ringNum == 1))
                            ? ArcTextPainter(
                                userChosenRadius: textParsingService
                                    .getMiddleVerticalRadius(),
                                textStyle: widget.pie.textStyle,
                                initialAngle: _animation.value + (pi / 2),
                                listOfChunkPhrases:
                                    textParsingService.getChunkPhraseList(),
                                forwardPhraseAlpha:
                                    textParsingService.getForwardAlphaList(),
                                listOfReverseChunkPhrases: textParsingService
                                    .getReversePhraseChunkList(),
                                reversePhraseAlpha:
                                    textParsingService.getReverseAlphaList(),
                                numChunks: widget.pie.items.length,
                                spaceBetweenLines:
                                    widget.spaceBetweenLines + 10,
                                isRing3: widget.pie.ringNum == 3,
                                isRotating: !isNotBeingRotated,
                              )
                            : PieTextPainter(
                                items: widget.items,
                                rotation: _animation.value,
                                toText: (item, _) => TextPainter(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: widget.pie.textStyle,
                                    text: item.name,
                                  ),
                                  textDirection: TextDirection.ltr,
                                ),
                                textRadiusCoefficient:
                                    widget.pie.textProportion,
                              ),
                      )
                    ],
                  );
                },
                child: CustomPaint(
                  painter: PieChartPainter(
                    items: widget.items,
                    linesColor: widget.linesColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
