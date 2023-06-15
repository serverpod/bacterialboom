import 'dart:math';

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

final noiseGrid = LoopingNoiseGrid(width: 512, height: 512, frequency: 1);

class BlobNode extends Node {
  BlobNode({
    required this.userId,
    required this.blobId,
    required this.maxVelocity,
    required this.radius,
    required this.colorIdx,
  }) {
    _fillPaint = Paint()..color = blobColors[colorIdx];
    _borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    Random random = Random();
    _animationVal = random.nextDouble();
  }

  final int userId;
  final int blobId;
  double maxVelocity;
  double radius;
  int colorIdx;

  late final Paint _fillPaint;
  late final Paint _borderPaint;

  late double _animationVal;

  @override
  void update(double dt) {
    super.update(dt);
    _animationVal += dt * 0.1;
    while (_animationVal > 1) {
      _animationVal -= 1;
    }
  }

  @override
  void paint(Canvas canvas) {
    var noiseCircle = noiseGrid.getCircle(
      xCenter: 0,
      yCenter: _animationVal * 512,
      radius: radius * 8,
      numPoints: 360,
    );

    var path = Path();
    for (var i = 0; i < 360; i++) {
      var rad = i * pi / 180;
      var variation = 1 * noiseCircle[i];
      var x = (radius + variation * 0.3 * radius) * cos(rad);
      var y = (radius + variation * 0.3 * radius) * sin(rad);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(
      path,
      _fillPaint,
    );

    // Stroke the path
    canvas.drawPath(
      path,
      _borderPaint,
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
