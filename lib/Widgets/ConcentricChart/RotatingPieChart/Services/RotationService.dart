import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../RotationEndSimulation.dart';

class RotationService {
  RotationService(this.direction);

  /// The dirction last dragged by the user
  late Offset direction;

  int translateAnimationPositionToChunkPosition(
      double animationPosition, int numChunks) {
    debugPrint("AnimationPosition: " + animationPosition.toString());
    debugPrint("numChunks: " + numChunks.toString());
    // 0.25 * 4 = 1;
    // 0.5 * 4 = 2;
    // 0.75 * 4 = 3
    // 1 * 4 = 4;;

    0.16666666666 * 6;
    double thing = (animationPosition / (1 / numChunks));
    debugPrint("What about: " + thing.toString());

    return (animationPosition % (1 / numChunks)).floor();
  }

  /// Gets the last direction to set [ direction]
  Offset getDirection(Offset globalPosition, BuildContext context) {
    RenderBox? box = context.findRenderObject() as RenderBox?;
    Offset? offset = box?.globalToLocal(globalPosition);
    Offset center =
        Offset(context.size!.width / 2.0, context.size!.height / 2.0);
    return offset! - center;
  }

  void setDirection(Offset direction) {
    this.direction = direction;
  }

  // Returns new Direction based on direction user is panning
  Offset getLastDirectionPanned(DragUpdateDetails details, BuildContext context,
      AnimationController controller) {
    Offset newDirection = getDirection(details.globalPosition, context);
    double diff = newDirection.direction - direction.direction;

    var value = controller.value + (diff / pi / 2);
    controller.value = value % 1.0;
    direction = newDirection;
    return newDirection;
  }

  void animateEndPanning(
      DragEndDetails details,
      double accelerationFactor,
      AnimationController controller,
      List<double> bounds,
      Function onRotationEnd) {
    // non-angular velocity
    Offset velocity = details.velocity.pixelsPerSecond;

    var top = (direction.dx * velocity.dy) - (direction.dy * velocity.dx);
    var bottom = (direction.dx * direction.dx) + (direction.dy * direction.dy);

    var angularVelocity = top / bottom;
    var angularRotation = angularVelocity / pi / 2;
    var decelleration = angularRotation * accelerationFactor;
    controller.animateWith(
      RotationEndSimulation(
        onRotationEnd: onRotationEnd,
        bounds: bounds,
        decelleration: decelleration,
        initialPosition: controller.value,
        initialVelocity: angularRotation,
      ),
    );
  }
}
