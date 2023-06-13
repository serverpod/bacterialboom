import 'dart:ui';

import 'package:spritewidget/spritewidget.dart';

class BlobNode extends Node {
  BlobNode({
    required this.userId,
    required this.blobId,
    required this.maxVelocity,
    required this.radius,
    required this.color,
  });

  final int userId;
  final int blobId;
  double maxVelocity;
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
