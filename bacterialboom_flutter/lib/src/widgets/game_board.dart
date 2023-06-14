import 'dart:async';

import 'package:bacterialboom_client/bacterialboom_client.dart';
import 'package:bacterialboom_flutter/main.dart';
import 'package:bacterialboom_flutter/src/game_nodes/game_board.dart';
import 'package:bacterialboom_flutter/src/game_nodes/game_view.dart';
import 'package:bacterialboom_flutter/src/widgets/game_controls.dart';
import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

class GameBoardWidget extends StatefulWidget {
  const GameBoardWidget({
    required this.gameState,
    required this.inputController,
    required this.onDone,
    Key? key,
  }) : super(key: key);

  final GameState gameState;
  final GameInputController inputController;
  final VoidCallback onDone;

  @override
  GameBoardWidgetState createState() => GameBoardWidgetState();
}

class GameBoardWidgetState extends State<GameBoardWidget> {
  late final GameBoard _gameBoard = GameBoard(
    gameState: widget.gameState,
    inputController: widget.inputController,
    userId: userId,
  );
  late final GameViewNode _gameView = GameViewNode(_gameBoard);
  late final int userId;

  bool _isDoneSent = false;

  @override
  void initState() {
    super.initState();
    userId = sessionManager.signedInUser!.id!;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _gameView.size = Size(constraints.maxWidth, constraints.maxHeight);
      return SpriteWidget(
        _gameView,
        transformMode: SpriteBoxTransformMode.nativePoints,
      );
    });
  }

  @override
  void didUpdateWidget(covariant GameBoardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _gameBoard.updateGameState(widget.gameState);
    if (!_gameBoard.isAlive && !_isDoneSent) {
      _isDoneSent = true;
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          widget.onDone();
        }
      });
    }
  }
}
