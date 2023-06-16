import 'dart:math';

import 'package:bacterialboom_flutter/main.dart';
import 'package:bacterialboom_flutter/src/game_nodes/game_object_node.dart';
import 'package:bacterialboom_flutter/src/resources/noise_grid.dart';
import 'package:flutter/material.dart';

const _gridSizeX = 64;
const _gridSizeY = 64;

class BackgroundParticlesNode extends GameObjectNode {
  BackgroundParticlesNode() {
    Random random = Random();
    _positionAnimationVal = random.nextDouble();
    _sizeAnimationVal = random.nextDouble();
  }

  late double _positionAnimationVal;
  late double _sizeAnimationVal;

  @override
  void update(double dt) {
    super.update(dt);

    _positionAnimationVal += dt * 0.02;
    while (_positionAnimationVal > 1) {
      _positionAnimationVal -= 1;
    }

    _sizeAnimationVal += dt * 0.01;
    while (_sizeAnimationVal > 1) {
      _sizeAnimationVal -= 1;
    }
  }

  @override
  void paint(Canvas canvas) {
    var spaceBetweenDotsX = gameBoardSize.width / _gridSizeX;
    var spaceBetweenDotsY = gameBoardSize.height / _gridSizeY;

    var frame = viewFrame;

    frame = Rect.fromLTWH(
      frame.left + 10,
      frame.top + 10,
      frame.width - 20,
      frame.height - 20,
    );

    int startX = (frame.left / spaceBetweenDotsX).floor();
    int endX = (frame.right / spaceBetweenDotsX).ceil();
    int startY = (frame.top / spaceBetweenDotsY).floor();
    int endY = (frame.bottom / spaceBetweenDotsY).ceil();

    startX = startX.clamp(0, _gridSizeX - 1);
    endX = endX.clamp(0, _gridSizeX - 1);
    startY = startY.clamp(0, _gridSizeY - 1);
    endY = endY.clamp(0, _gridSizeY - 1);

    var paint = Paint()
      ..filterQuality = FilterQuality.low
      ..isAntiAlias = false
      ..blendMode = BlendMode.srcATop;

    var texture = resourceManager.blobParticle;

    var transforms = <RSTransform>[];
    var rects = <Rect>[];
    var colors = <Color>[];

    for (var i = startX; i <= endX; i += 1) {
      for (var j = startY; j <= endY; j += 1) {
        var x = i * spaceBetweenDotsX;
        var y = j * spaceBetweenDotsY;

        var xVar = noiseGrid.getInterpolated(
          _positionAnimationVal * noiseGridSize,
          i + j * 61,
        );
        x += xVar * spaceBetweenDotsX * 2;

        var yVar = noiseGrid.getInterpolated(
          _positionAnimationVal * noiseGridSize,
          j + i * 61,
        );
        y += yVar * spaceBetweenDotsY * 2;

        var sizeVar = noiseGrid.getInterpolated(
          _sizeAnimationVal * noiseGridSize,
          i + j * 27,
        );

        var opacityVar = noiseGrid.getInterpolated(
          _sizeAnimationVal * noiseGridSize,
          j + i * 27,
        );

        var rect = texture.frame;
        rects.add(rect);

        var transform = RSTransform.fromComponents(
          rotation: rotation,
          scale: 0.02 + sizeVar * 0.016,
          anchorX: rect.width / 2,
          anchorY: rect.height / 2,
          translateX: x,
          translateY: y,
        );
        transforms.add(transform);

        var color = Colors.white.withOpacity(0.3 + opacityVar * 0.29);
        colors.add(color);
      }
    }

    canvas.drawAtlas(
      texture.image,
      transforms,
      rects,
      colors,
      BlendMode.modulate,
      null,
      paint,
    );

    // canvas.drawRect(frame, paint);
  }
}
