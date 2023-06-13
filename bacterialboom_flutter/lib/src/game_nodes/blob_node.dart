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
