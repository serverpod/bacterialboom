import 'dart:math';

import 'package:bacterialboom_flutter/main.dart';
import 'package:bacterialboom_flutter/src/game_nodes/game_object_node.dart';
import 'package:bacterialboom_flutter/src/resources/noise_grid.dart';
import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

const _gridSizeX = 50;
const _gridSizeY = 50;

class BackgroundParticlesLayerNode extends GameObjectNode {
  BackgroundParticlesLayerNode() {
    Random random = Random();
    _positionAnimationVal = random.nextDouble();
    _sizeAnimationVal = random.nextDouble();
  }

  late double _positionAnimationVal;
  late double _sizeAnimationVal;

  final _colorSequence = ColorSequence(
    colors: [
      Colors.lightGreen[700]!,
      Colors.blue[500]!,
      Colors.teal[500]!,
      Colors.green[500]!,
    ],
    stops: [0.0, 0.33, 0.66, 1.0],
  );

  @override
  void update(double dt) {
    super.update(dt);

    _positionAnimationVal += dt * 0.003;
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
      ..blendMode = BlendMode.plus;

    var texture = resourceManager.sporeParticle;

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
        x += xVar * spaceBetweenDotsX * 4;

        var yVar = noiseGrid.getInterpolated(
          _positionAnimationVal * noiseGridSize,
          j + i * 61,
        );
        y += yVar * spaceBetweenDotsY * 4;

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
          scale: 0.03 + sizeVar * 0.01,
          anchorX: rect.width / 2,
          anchorY: rect.height / 2,
          translateX: x,
          translateY: y,
        );
        transforms.add(transform);

        // var color = Colors.white.withOpacity((0.3 + opacityVar * 0.29) * scale);
        var color = _colorSequence
            .colorAtPosition(opacityVar * 0.5 + 0.5)
            .withOpacity(((0.5 + opacityVar * 0.49) * scale * 4).clamp(0, 1));
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

class BackgroundNode extends GameObjectNode {
  Offset? _localStartingCenter;

  BackgroundNode() {
    _layers.add(BackgroundParticlesLayerNode()..scale = 0.5);
    _layers.add(BackgroundParticlesLayerNode()..scale = 0.75);
    _layers.add(BackgroundParticlesLayerNode());

    for (var layer in _layers) {
      addChild(layer);
    }
  }

  Offset _layerPosition(double layerScale) {
    if (layerScale == 1) {
      return Offset.zero;
    }

    if (_localStartingCenter == null) {
      var viewSize = gameView.size;
      var globalStartingCenter = Offset(
        viewSize.width / 2,
        viewSize.height / 2,
      );
      _localStartingCenter = convertPointToNodeSpace(globalStartingCenter);
    }

    var viewSize = gameView.size;
    var globalStartingCenter = Offset(
      viewSize.width / 2,
      viewSize.height / 2,
    );
    var localCenter = convertPointToNodeSpace(globalStartingCenter);

    var localOffset = localCenter - _localStartingCenter!;

    return localOffset * layerScale;
  }

  final _layers = <BackgroundParticlesLayerNode>[];

  @override
  void update(double dt) {
    for (var layer in _layers) {
      layer.position = -_layerPosition(layer.scale);
    }
  }

  @override
  void paint(Canvas canvas) {
    // Background.
    var backgroundOffset = _layerPosition(0.1);
    var backgroundMatrix = Matrix4.identity();
    backgroundMatrix.translate(backgroundOffset.dx, backgroundOffset.dy);
    backgroundMatrix.scale(4.0);

    var backgroundShader = ImageShader(
      resourceManager.backgroundImage,
      TileMode.repeated,
      TileMode.repeated,
      backgroundMatrix.storage,
    );

    var backgroundPaint = Paint()
      ..shader = backgroundShader
      ..filterQuality = FilterQuality.low;

    canvas.drawRect(viewFrame, backgroundPaint);

    // Background overlay 1.
    var backgroundOverlayOffset = _layerPosition(0.2);
    var backgroundOverlayMatrix = Matrix4.identity();
    backgroundOverlayMatrix.translate(
        backgroundOverlayOffset.dx, backgroundOverlayOffset.dy);
    backgroundOverlayMatrix.scale(0.3);

    var backgroundOverlayShader = ImageShader(
      resourceManager.backgroundOverlayImage,
      TileMode.repeated,
      TileMode.repeated,
      backgroundOverlayMatrix.storage,
    );

    var backgroundOverlayPaint = Paint()
      ..shader = backgroundOverlayShader
      ..filterQuality = FilterQuality.low
      ..blendMode = BlendMode.plus;

    canvas.drawRect(viewFrame, backgroundOverlayPaint);

    // Background overlay 2.
    var backgroundOverlayOffset2 = _layerPosition(0.3);
    var backgroundOverlayMatrix2 = Matrix4.identity();
    backgroundOverlayMatrix2.translate(
        backgroundOverlayOffset2.dx, backgroundOverlayOffset2.dy);
    backgroundOverlayMatrix2.scale(0.4);

    var backgroundOverlayShader2 = ImageShader(
      resourceManager.backgroundOverlayImage,
      TileMode.repeated,
      TileMode.repeated,
      backgroundOverlayMatrix2.storage,
    );

    var backgroundOverlayPaint2 = Paint()
      ..shader = backgroundOverlayShader2
      ..filterQuality = FilterQuality.low
      ..blendMode = BlendMode.plus;

    canvas.drawRect(viewFrame, backgroundOverlayPaint2);
  }
}
