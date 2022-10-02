import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:provider/provider.dart';

class Wheel extends StatefulWidget {
  const Wheel({Key? key}) : super(key: key);

  @override
  State<Wheel> createState() => _WheelState();
}

class _WheelState extends State<Wheel> with SingleTickerProviderStateMixin {
  late AnimationController _wheelAnimationController;
  bool _isSnapping = false;
  double _radius = 20.0; // Probably set this in the constructor.
  static const double velocitySnapThreshold = 1.0;
  static const double distanceSnapThreshold = 0.25;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of(context);

    _wheelAnimationController =
        AnimationController.unbounded(vsync: this, value: provider.wheelAngle);
    _wheelAnimationController.addListener(() {
      if (!_isSnapping) {
        // Snap to an item if not spinning quickly.
        var wheelAngle = _wheelAnimationController.value;
        var velocity = _wheelAnimationController.velocity.abs();
        var closestSnapAngle = getClosestSnapAngle(wheelAngle);
        var distance = (closestSnapAngle - wheelAngle).abs();

        if (velocity == 0 ||
            (velocity < velocitySnapThreshold &&
                distance < distanceSnapThreshold)) {
          snapTo(closestSnapAngle);
        }
      }
      provider.wheelAngle = _wheelAnimationController.value;
    });

    return Stack(
      children: [
        const Center(
          child: Text("HELLO"),
        ),
        // ... <-- Visible things go here
        // Vertical dragging anywhere on the screen rotates the wheel, hence the SafeArea.
        SafeArea(
          child: GestureDetector(
            onVerticalDragDown: (details) {
              _wheelAnimationController.stop();
              _isSnapping = false;
            },
            onVerticalDragUpdate: (offset) => provider.wheelAngle =
                provider.wheelAngle + atan(offset.delta.dy / _radius),
            onVerticalDragEnd: (details) =>
                onRotationEnd(provider, details.primaryVelocity),
            child: Text("Hello there"),
          ),
        ),
      ],
    );
  }

  double getClosestSnapAngle(double currentAngle) {
    // Do what you gotta do here.
    return 0.0;
  }

  void snapTo(double snapAngle) {
    var wheelAngle = _wheelAnimationController.value;
    _wheelAnimationController.stop();
    _isSnapping = true;
    var springSimulation = SpringSimulation(
      SpringDescription(mass: 20.0, stiffness: 10.0, damping: 1.0),
      wheelAngle,
      snapAngle,
      _wheelAnimationController.velocity,
    );
    _wheelAnimationController.animateWith(springSimulation);
  }

  void onRotationEnd(WheelAngleProvider provider, double? velocity) {
    // When velocity is not null, this is the result of a fling and it needs to spin freely.
    if (velocity != null) {
      _wheelAnimationController.stop();

      var frictionSimulation =
          FrictionSimulation(0.5, provider.wheelAngle, velocity / 200);
      _wheelAnimationController.animateWith(frictionSimulation);
    }
  }
}

class WheelAngleProvider {
  double wheelAngle;
  WheelAngleProvider(this.wheelAngle);
}
