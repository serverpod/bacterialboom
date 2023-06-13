import 'package:bacterialboom_flutter/src/game_nodes/game_controls.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:spritewidget/spritewidget.dart';

class GameControlsWidget extends StatefulWidget {
  final GameInputController controller;

  const GameControlsWidget({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<GameControlsWidget> createState() => GameControlsWidgetState();
}

class GameControlsWidgetState extends State<GameControlsWidget> {
  late final GameControls _gameControls = GameControls();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller._state = this;
    HardwareKeyboard.instance.addHandler(_handleKeyboardEvent);
  }

  @override
  void dispose() {
    super.dispose();
    HardwareKeyboard.instance.removeHandler(_handleKeyboardEvent);
  }

  bool _spaceDown = false;

  bool _handleKeyboardEvent(KeyEvent event) {
    if (!mounted) {
      return false;
    }
    if (event.logicalKey == LogicalKeyboardKey.space) {
      if (event is KeyDownEvent) {
        if (!_spaceDown) {
          widget.controller.onPerformAction?.call();
        }
        _spaceDown = true;
      }
      if (event is KeyUpEvent) {
        _spaceDown = false;
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _gameControls.size = Size(constraints.maxWidth, constraints.maxHeight);
      return GestureDetector(
        onDoubleTap: () {
          widget.controller.onPerformAction?.call();
        },
        child: SpriteWidget(
          _gameControls,
          transformMode: SpriteBoxTransformMode.nativePoints,
        ),
      );
    });
  }

  Offset get joystickValue => _gameControls.value;
}

class GameInputController {
  VoidCallback? onPerformAction;

  GameInputController();

  GameControlsWidgetState? _state;

  Offset get joystickValue => _state?.joystickValue ?? Offset.zero;
}
