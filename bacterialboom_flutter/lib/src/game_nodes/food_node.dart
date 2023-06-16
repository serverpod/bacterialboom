import 'dart:math';

import 'package:bacterialboom_flutter/src/game_nodes/game_object_node.dart';
import 'package:bacterialboom_flutter/src/resources/noise_grid.dart';
import 'package:bacterialboom_flutter/src/util.dart/qsin.dart';
import 'package:flutter/material.dart';

class FoodNode extends GameObjectNode {
  FoodNode({
    required this.foodId,
    required this.radius,
  }) {
    _borderPaint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    var color1 = Colors.green.withOpacity(0.5);
    var color2 = Colors.green.withOpacity(0.9);
    var gradient = RadialGradient(
      colors: [color1, color2],
      stops: const [0.0, 1.0],
    );

    _fillPaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(
        center: Offset.zero,
        radius: radius + 1,
      ));

    Random random = Random();
    _foodShapeAnimationVal = random.nextDouble();

    _noiseOffset = (random.nextDouble() * noiseGridSize).floor();
  }

  final int foodId;

  double radius;

  late double _foodShapeAnimationVal;
  late int _noiseOffset;

  late final Paint _borderPaint;
  late final Paint _fillPaint;

  @override
  void update(double dt) {
    super.update(dt);

    _foodShapeAnimationVal += dt * 0.1;
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

    const numPoints = 45;

    var mainNoiseCircle = noiseGrid.getCircle(
      xCenter: _noiseOffset.toDouble(),
      yCenter: _foodShapeAnimationVal * noiseGridSize,
      radius: 40,
      numPoints: numPoints,
    );

    var mainXs = List.filled(numPoints, 0.0);
    var mainYs = List.filled(numPoints, 0.0);

    // // Caluclate path points.
    for (var i = 0; i < numPoints; i++) {
      var rad = i * 2 * pi / numPoints;

      var mainVariation = 0.5 * mainNoiseCircle[i];

      mainXs[i] = (radius + mainVariation * radius) * qcos(rad);
      mainYs[i] = (radius + mainVariation * radius) * qsin(rad);
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

    canvas.drawPath(
      mainPath,
      _fillPaint,
    );

    canvas.drawPath(
      mainPath,
      _borderPaint,
    );
  }
}
