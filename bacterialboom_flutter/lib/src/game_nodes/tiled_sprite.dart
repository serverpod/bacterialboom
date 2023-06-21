import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

class TiledSprite extends NodeWithSize {
  TiledSprite({
    required this.image,
    required Size size,
    this.blendMode = ui.BlendMode.srcOver,
  }) : super(size);

  final ui.Image image;
  final ui.BlendMode blendMode;
  Offset offset = Offset.zero;
  double imageScale = 1.0;

  @override
  void paint(ui.Canvas canvas) {
    canvas.save();
    applyTransformForPivot(canvas);

    // Draw background
    var backgroundMatrix = Matrix4.identity();
    backgroundMatrix.translate(offset.dx, offset.dy);
    backgroundMatrix.scale(imageScale);

    var backgroundShader = ImageShader(
      image,
      TileMode.repeated,
      TileMode.repeated,
      backgroundMatrix.storage,
    );

    var backgroundPaint = Paint()
      ..shader = backgroundShader
      ..filterQuality = FilterQuality.low
      ..blendMode = blendMode;

    canvas.drawRect(
      Rect.fromLTWH(
        0.0,
        0.0,
        size.width,
        size.height,
      ),
      backgroundPaint,
    );

    canvas.restore();
  }
}
