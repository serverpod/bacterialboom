import 'dart:ui';
import 'package:spritewidget/spritewidget.dart';

class GameControls extends NodeWithSize {
  final VirtualJoystick _joystick = VirtualJoystick();

  GameControls() : super(const Size(1024, 1024)) {
    _joystick.position = Offset(size.width / 2, size.height / 2);
    addChild(_joystick);
  }

  @override
  set size(Size size) {
    super.size = size;
    _joystick.position = Offset(size.width / 2, size.height);
  }

  Offset get value => _joystick.value;
}
