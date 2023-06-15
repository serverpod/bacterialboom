import 'dart:math';

import 'package:bacterialboom_flutter/src/game_nodes/blob_node.dart';
import 'package:bacterialboom_flutter/src/game_nodes/game_object_node.dart';
import 'package:flutter/material.dart';

class FoodNode extends GameObjectNode {
  FoodNode({
    required this.radius,
  }) {
    Random random = Random();
    _foodShapeAnimationVal = random.nextDouble();

    _noiseOffset = (random.nextDouble() * noiseGrid.width).floor();
  }

  double radius;

  late double _foodShapeAnimationVal;
  late int _noiseOffset;

  @override
  void update(double dt) {
    super.update(dt);

    _foodShapeAnimationVal += dt * 0.001;
    while (_foodShapeAnimationVal > 1) {
      _foodShapeAnimationVal -= 1;
    }
  }

  @override
  void paint(Canvas canvas) {
    // Don't draw if not in view.
    if (!isInViewFrame(radius)) {
      return;
    }

    const numPoints = 360;

    var mainNoiseCircle = noiseGrid.getCircle(
      xCenter: _noiseOffset.toDouble(),
      yCenter: _foodShapeAnimationVal * noiseGrid.height,
      radius: 64,
      numPoints: numPoints,
    );

    var mainXs = List.filled(numPoints, 0.0);
    var mainYs = List.filled(numPoints, 0.0);

    // // Caluclate path points.
    for (var i = 0; i < numPoints; i++) {
      var rad = i * 2 * pi / numPoints;

      var mainVariation = 0.3 * mainNoiseCircle[i];

      mainXs[i] = (radius + mainVariation * radius) * cos(rad);
      mainYs[i] = (radius + mainVariation * radius) * sin(rad);
    }

    // Build paths.
    var mainPath = Path();
    for (var i = 0; i < numPoints; i += 1) {
      if (i == 0) {
        mainPath.moveTo(mainXs[i], mainYs[i]);
      } else {
        mainPath.lineTo(mainXs[i], mainYs[i]);
      }
    }
    mainPath.close();

    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()..color = Colors.blue,
    );

    canvas.drawPath(
      mainPath,
      Paint()..color = Colors.green,
    );
  }
}
