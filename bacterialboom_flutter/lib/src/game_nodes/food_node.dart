import 'dart:math';

import 'package:bacterialboom_flutter/main.dart';
import 'package:bacterialboom_flutter/src/game_nodes/game_object_node.dart';
import 'package:bacterialboom_flutter/src/resources/noise_grid.dart';
import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

class FoodNode extends GameObjectNode {
  FoodNode({
    required this.foodId,
    required this.radius,
  }) {
    Random random = Random();
    _noiseOffset = random.nextDouble() * noiseGridSize;
    _rotationAnimationVal = random.nextDouble();

    _foodSprite = Sprite(texture: resourceManager.foodSprite);
    addChild(_foodSprite);

    motions.run(
      MotionTween(
        setter: (double a) => _foodSprite.scale = a,
        start: 0.001,
        end: radius * 0.015,
        duration: 1.0,
        curve: Curves.bounceOut,
      ),
    );
  }

  final int foodId;
  double radius;

  late Sprite _foodSprite;
  late double _rotationAnimationVal;
  late double _noiseOffset;

  @override
  void update(double dt) {
    super.update(dt);

    _rotationAnimationVal += dt * 0.1;
    while (_rotationAnimationVal > 1) {
      _rotationAnimationVal -= 1;
    }

    var noise = noiseGrid.getInterpolated(
      _noiseOffset,
      _rotationAnimationVal * noiseGridSize,
    );

    _foodSprite.rotation = noise * 360;
  }
}
