import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

class FoodNode extends Node {
  FoodNode({
    required this.radius,
  });

  double radius;

  @override
  void paint(Canvas canvas) {
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()..color = Colors.green,
    );
  }
}
