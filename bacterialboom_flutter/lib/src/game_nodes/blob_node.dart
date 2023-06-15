import 'dart:math';

import 'package:bacterialboom_flutter/src/util.dart/mod.dart';
import 'package:bacterialboom_flutter/src/util.dart/noise.dart';
import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

final blobColors = <Color>[
  Colors.red,
  Colors.blue,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.teal,
  Colors.pink,
  Colors.cyan,
];

const _noiseGridSize = 512;

final noiseGrid = LoopingNoiseGrid(
  width: _noiseGridSize,
  height: _noiseGridSize,
  frequency: 1,
);

class BlobNode extends Node {
  BlobNode({
    required this.userId,
    required this.blobId,
    required this.maxVelocity,
    required this.radius,
    required this.colorIdx,
  }) {
    _borderPaintSmooth = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    _borderPaintMiter = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.round;

    Random random = Random();
    _blobShapeAnimationVal = random.nextDouble();
    _spikeRotationAnimationVal = random.nextDouble();
    _blobFocalPointAnimationVal = random.nextDouble();

    _noiseOffset = (random.nextDouble() * _noiseGridSize).floor();

    zPosition = 10;
  }

  final int userId;
  final int blobId;
  double maxVelocity;
  double radius;
  int colorIdx;

  late final Paint _borderPaintSmooth;
  late final Paint _borderPaintMiter;
  late final int _noiseOffset;

  late double _blobShapeAnimationVal;
  late double _blobFocalPointAnimationVal;
  late double _spikeRotationAnimationVal;

  @override
  void update(double dt) {
    super.update(dt);

    _blobShapeAnimationVal += dt * 0.1;
    while (_blobShapeAnimationVal > 1) {
      _blobShapeAnimationVal -= 1;
    }

    _spikeRotationAnimationVal += dt * 0.13;
    while (_spikeRotationAnimationVal > 1) {
      _spikeRotationAnimationVal -= 1;
    }

    _blobFocalPointAnimationVal += dt * 0.052;
    while (_blobFocalPointAnimationVal > 1) {
      _blobFocalPointAnimationVal -= 1;
    }
  }

  @override
  void paint(Canvas canvas) {
    const numPoints = 360;
    const spikeLength = 3.0;
    const spikeWidth = 4;

    var mainNoiseCircle = noiseGrid.getCircle(
      xCenter: _noiseOffset.toDouble(),
      yCenter: _blobShapeAnimationVal * _noiseGridSize,
      radius: radius * 8,
      numPoints: numPoints,
    );

    var subNoiseCircle = noiseGrid.getCircle(
      xCenter: _noiseOffset * 2,
      yCenter: _blobShapeAnimationVal * _noiseGridSize,
      radius: radius * 16,
      numPoints: numPoints,
    );

    var numSpikes = (radius * 2).round();

    var mainXs = List.filled(numPoints, 0.0);
    var mainYs = List.filled(numPoints, 0.0);

    var subXs = List.filled(numPoints, 0.0);
    var subYs = List.filled(numPoints, 0.0);

    // Caluclate path points.
    for (var i = 0; i < numPoints; i++) {
      var rad = i * 2 * pi / numPoints;

      var mainVariation = 1.0 * mainNoiseCircle[i];
      var subVariation = 1.0 * subNoiseCircle[i];

      mainXs[i] = (radius + mainVariation * 0.3 * radius) * cos(rad);
      mainYs[i] = (radius + mainVariation * 0.3 * radius) * sin(rad);

      subXs[i] =
          (radius + mainVariation * 0.3 * radius) * cos(rad) + subVariation * 1;
      subYs[i] =
          (radius + mainVariation * 0.3 * radius) * sin(rad) + subVariation * 1;
    }

    // Add spikes.
    var rotVariation = noiseGrid.get(
      (_spikeRotationAnimationVal * _noiseGridSize).floor(),
      _noiseOffset,
    );

    for (var i = 0; i < numSpikes; i++) {
      // var rad = i * pi / numSpikes * 2;
      // rad += rotVariation * 0.5;
      var pathIdx = (i * numPoints / numSpikes).floor();
      pathIdx = (rotVariation * 90 + pathIdx).floor();
      var rad = pathIdx * 2 * pi / numPoints;

      for (int j = 0; j < spikeWidth; j++) {
        var modIdx = mod(pathIdx + j, numPoints);

        mainXs[modIdx] += spikeLength * cos(rad);
        mainYs[modIdx] += spikeLength * sin(rad);
      }
    }

    // Build paths.
    var mainPath = Path();
    var subPath = Path();
    for (var i = 0; i < numPoints; i += 1) {
      if (i == 0) {
        mainPath.moveTo(mainXs[i], mainYs[i]);
        subPath.moveTo(subXs[i], subYs[i]);
      } else {
        mainPath.lineTo(mainXs[i], mainYs[i]);
        subPath.lineTo(subXs[i], subYs[i]);
      }
    }
    mainPath.close();
    subPath.close();

    // Create gradient fill.
    var focalX = noiseGrid.get(
          (_blobFocalPointAnimationVal * _noiseGridSize).floor(),
          _noiseOffset,
        ) *
        0.8;
    var focalY = noiseGrid.get(
          _noiseOffset,
          (_blobFocalPointAnimationVal * _noiseGridSize).floor(),
        ) *
        0.8;

    var color1 = blobColors[colorIdx].withOpacity(0.5);
    var color2 = color1.withOpacity(0.9);
    var gradient = RadialGradient(
      focal: Alignment(focalX, focalY),
      colors: [color2, color1, color2],
      stops: const [0.2, 0.6, 0.9],
    );

    var fillPaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(
        center: Offset.zero,
        radius: radius * 1.3 + spikeLength + 1,
      ));

    canvas.drawPath(
      mainPath,
      _borderPaintMiter,
    );

    canvas.drawPath(
      mainPath,
      fillPaint,
    );

    // Stroke the path

    canvas.drawPath(
      subPath,
      _borderPaintSmooth,
    );
  }

  void constrainPosition() {
    if (parent == null) {
      return;
    }
    var world = parent as NodeWithSize;

    if (position.dx < radius) {
      position = Offset(radius, position.dy);
    } else if (position.dx > world.size.width - radius) {
      position = Offset(world.size.width - radius, position.dy);
    }
    if (position.dy < radius) {
      position = Offset(position.dx, radius);
    } else if (position.dy > world.size.height - radius) {
      position = Offset(position.dx, world.size.height - radius);
    }
  }
}
