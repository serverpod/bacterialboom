import 'dart:ui';

import 'package:spritewidget/spritewidget.dart';

class BackgroundNode extends NodeWithSize {
  final Color color;

  BackgroundNode(Size size, this.color) : super(size);

  @override
  void paint(Canvas canvas) {
    super.paint(canvas);
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        Paint()..color = color);
  }
}
