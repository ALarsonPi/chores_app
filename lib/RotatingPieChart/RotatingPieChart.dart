import 'dart:ffi';
import 'dart:math';
import 'package:chore_app/RotatingPieChart/PieChartItem.dart';
import 'package:chore_app/RotatingPieChart/PiePainter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class RotatingPieChart extends StatelessWidget {
  final double accellerationFactor;
  final List<PieChartItem> items;
  final PieChartItemToText toText;
  final double sizeOfChart;

  const RotatingPieChart(
      {Key? key,
      this.accellerationFactor = 1.0,
      required this.items,
      required this.toText,
      this.sizeOfChart = 250})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: sizeOfChart,
        //width: sizeOfChart,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: _RotatingPieChartInternal(
            items: items,
            toText: toText,
            accellerationFactor: accellerationFactor,
          ),
        ),
      ),
    );
  }
}

class _RotationEndSimulation extends Simulation {
  final double initialVelocity;
  final double initialPosition;
  final double accelleration;

  _RotationEndSimulation({
    required this.initialVelocity,
    required double decelleration,
    required this.initialPosition,
  }) : accelleration = decelleration * -1.0;

  @override
  double dx(double time) => initialVelocity + (accelleration * time);

  @override
  bool isDone(double time) =>
      initialVelocity > 0 ? dx(time) < 0.001 : dx(time) > -0.001;

  @override
  double x(double time) =>
      (initialPosition +
          (initialVelocity * time) +
          (accelleration * time * time / 2)) %
      1.0;
}

class _RotatingPieChartInternal extends StatefulWidget {
  final double accellerationFactor;
  final List<PieChartItem> items;
  final PieChartItemToText toText;

  const _RotatingPieChartInternal(
      {Key? key,
      this.accellerationFactor = 1.0,
      required this.items,
      required this.toText})
      : super(key: key);

  @override
  _RotatingPieChartInternalState createState() =>
      _RotatingPieChartInternalState();
}

class _RotatingPieChartInternalState extends State<_RotatingPieChartInternal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _animation = Tween(begin: 0.0, end: 2.0 * pi).animate(_controller);
    _controller.animateTo(2 * pi, duration: const Duration(seconds: 10));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late Offset lastDirection;

  Offset getDirection(Offset globalPosition) {
    RenderBox? box = context.findRenderObject() as RenderBox?;
    Offset? offset = box?.globalToLocal(globalPosition);
    Offset center =
        Offset(context.size!.width / 2.0, context.size!.height / 2.0);
    return offset! - center;
  }

  bool _isSnapping = false;
  void snapTo(double snapAngle) {
    var wheelAngle = _controller.value;
    _controller.stop();
    _isSnapping = true;
    var springSimulation = SpringSimulation(
      SpringDescription(mass: 20.0, stiffness: 10.0, damping: 1.0),
      wheelAngle,
      snapAngle,
      _controller.velocity,
    );
    _controller.animateWith(springSimulation);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) {
        lastDirection = getDirection(details.globalPosition);
      },
      onPanUpdate: (details) {
        Offset newDirection = getDirection(details.globalPosition);
        double diff = newDirection.direction - lastDirection.direction;

        var value = _controller.value + (diff / pi / 2);
        _controller.value = value % 1.0;
        lastDirection = newDirection;
      },
      onPanEnd: (details) {
        // non-angular velocity
        Offset velocity = details.velocity.pixelsPerSecond;

        var top =
            (lastDirection.dx * velocity.dy) - (lastDirection.dy * velocity.dx);
        var bottom = (lastDirection.dx * lastDirection.dx) +
            (lastDirection.dy * lastDirection.dy);

        var angularVelocity = top / bottom;
        var angularRotation = angularVelocity / pi / 2;
        var decelleration = angularRotation * widget.accellerationFactor;
        //snapTo(30);
        _controller.animateWith(
          _RotationEndSimulation(
            decelleration: decelleration,
            initialPosition: _controller.value,
            initialVelocity: angularRotation,
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, widget) {
          return Stack(
            fit: StackFit.passthrough,
            children: [
              Transform.rotate(
                angle: _animation.value,
                child: widget,
              ),
              CustomPaint(
                painter: PieTextPainter(
                    items: this.widget.items,
                    rotation: _animation.value,
                    toText: this.widget.toText),
              )
            ],
          );
        },
        child: CustomPaint(
          painter: PieChartPainter(
            items: widget.items,
          ),
        ),
      ),
    );
  }
}
