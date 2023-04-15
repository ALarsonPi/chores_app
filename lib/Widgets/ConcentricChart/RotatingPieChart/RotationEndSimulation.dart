import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

class RotationEndSimulation extends Simulation {
  final double initialVelocity;
  final double initialPosition;
  final double accelleration;
  final List<double> bounds;
  final Function onRotationEnd;

  RotationEndSimulation({
    required this.initialVelocity,
    required double decelleration,
    required this.initialPosition,
    required this.onRotationEnd,
    required this.bounds,
  }) : accelleration = decelleration * -1.0;

  @override
  double dx(double time) => initialVelocity + (accelleration * time);

  @override
  bool isDone(double time) {
    bool hasFinishedRotation =
        initialVelocity > 0 ? dx(time) < 0.001 : dx(time) > -0.001;
    if (hasFinishedRotation) {
      onRotationEnd();
    }
    return hasFinishedRotation;
  }

  List<double> getCurrentBounds(double xPosition) {
    List<double> currentBounds = List.empty(growable: true);
    //Go Backwards
    if (xPosition >= 0.5) {
      for (int i = bounds.length - 1; i > 0; i--) {
        if (bounds[i] <= xPosition) {
          currentBounds.add(bounds[i]);
          currentBounds.add(bounds[i + 1]);
        }
      }
    }
    //Go forwards
    else {
      for (int i = 0; i < bounds.length; i++) {
        if (bounds[i] > xPosition) {
          currentBounds.add(bounds[i]);
          currentBounds.add(bounds[i - 1]);
          break;
        }
      }
    }
    return currentBounds;
  }

  double getClosestBound(double xPosition) {
    List<double> lowHighBounds = getCurrentBounds(xPosition);
    if ((xPosition - lowHighBounds[0]).abs() <
        (xPosition - lowHighBounds[1]).abs()) {
      return lowHighBounds[0];
    } else {
      return lowHighBounds[1];
    }
  }

  @override
  double x(double time) {
    double xPosition = (initialPosition +
            (initialVelocity * time) +
            (accelleration * time * time / 2)) %
        1.0;
    if (initialVelocity > 0 ? dx(time) < 0.003 : dx(time) > -0.003) {
      xPosition = getClosestBound(xPosition);
      if (xPosition == 1) xPosition = 0;
    }
    return xPosition;
  }
}
