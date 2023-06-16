import 'dart:math';

import 'package:bacterialboom_flutter/main.dart';
import 'package:bacterialboom_flutter/src/game_nodes/game_object_node.dart';
import 'package:bacterialboom_flutter/src/resources/noise_grid.dart';
import 'package:flutter/material.dart';

const _gridSizeX = 64;
const _gridSizeY = 64;

class BackgroundParticlesLayerNode extends GameObjectNode {
  BackgroundParticlesLayerNode() {
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
    var spaceBetweenDotsX = gameBoard.size.width / _gridSizeX;
    var spaceBetweenDotsY = gameBoard.size.height / _gridSizeY;

    var frame = viewFrame;

    frame = Rect.fromLTWH(
      frame.left + 32,
      frame.top + 32,
      frame.width - 64,
      frame.height - 64,
    );

    int startX = (frame.left / spaceBetweenDotsX).floor();
    int endX = (frame.right / spaceBetweenDotsX).ceil();
    int startY = (frame.top / spaceBetweenDotsY).floor();
    int endY = (frame.bottom / spaceBetweenDotsY).ceil();

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

        var color = Colors.white.withOpacity((0.3 + opacityVar * 0.29) * scale);
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

    // canvas.drawRect(frame, Paint()..color = Colors.blue.withOpacity(0.5));
  }
}

class BackgroundParticlesNode extends GameObjectNode {
  Offset? _localStartingCenter;

  BackgroundParticlesNode() {
    _layers.add(BackgroundParticlesLayerNode()..scale = 0.5);
    _layers.add(BackgroundParticlesLayerNode()..scale = 0.75);
    _layers.add(BackgroundParticlesLayerNode());

    for (var layer in _layers) {
      addChild(layer);
    }
  }

  final _layers = <BackgroundParticlesLayerNode>[];

  @override
  void update(double dt) {
    if (_localStartingCenter == null) {
      var viewSize = gameView.size;
      var globalStartingCenter = Offset(
        viewSize.width / 2,
        viewSize.height / 2,
      );
      _localStartingCenter = convertPointToNodeSpace(globalStartingCenter);
    }

    for (var layer in _layers) {
      if (layer.scale == 1) {
        continue;
      }
      var viewSize = gameView.size;
      var globalStartingCenter = Offset(
        viewSize.width / 2,
        viewSize.height / 2,
      );
      var localCenter = convertPointToNodeSpace(globalStartingCenter);

      var localOffset = localCenter - _localStartingCenter!;

      layer.position = localOffset * layer.scale;
    }
  }
}
