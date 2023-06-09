import 'dart:ui';

import 'package:spritewidget/spritewidget.dart';

class BlobNode extends Node {
  BlobNode({
    required this.radius,
    required this.color,
  });

  double radius;
  Color color;

  @override
  void paint(Canvas canvas) {
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()..color = color,
    );
  }
}
