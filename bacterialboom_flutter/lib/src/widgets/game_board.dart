import 'package:bacterialboom_client/bacterialboom_client.dart';
import 'package:bacterialboom_flutter/main.dart';
import 'package:bacterialboom_flutter/src/game_nodes/game_board.dart';
import 'package:bacterialboom_flutter/src/widgets/game_controls.dart';
import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

class GameBoardWidget extends StatefulWidget {
  const GameBoardWidget({
    required this.gameState,
    required this.inputController,
    Key? key,
  }) : super(key: key);

  final GameState gameState;
  final GameInputController inputController;

  @override
  GameBoardWidgetState createState() => GameBoardWidgetState();
}

class GameBoardWidgetState extends State<GameBoardWidget> {
  late final GameBoard _gameBoard = GameBoard(
    gameState: widget.gameState,
    inputController: widget.inputController,
    userId: userId,
  );
  late final int userId;

  @override
  void initState() {
    super.initState();
    userId = sessionManager.signedInUser!.id!;
  }

  @override
  Widget build(BuildContext context) {
    return SpriteWidget(
      _gameBoard,
      transformMode: SpriteBoxTransformMode.scaleToFit,
    );
  }

  @override
  void didUpdateWidget(covariant GameBoardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _gameBoard.updateGameState(widget.gameState);
  }
}
