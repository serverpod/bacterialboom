import 'package:bacterialboom_client/bacterialboom_client.dart';
import 'package:bacterialboom_flutter/main.dart';
import 'package:bacterialboom_flutter/src/game_nodes/blob_node.dart';
import 'package:bacterialboom_flutter/src/game_nodes/food_node.dart';
import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

class GameBoardWidget extends StatefulWidget {
  const GameBoardWidget({
    required this.gameState,
    Key? key,
  }) : super(key: key);

  final GameState gameState;

  @override
  GameBoardWidgetState createState() => GameBoardWidgetState();
}

class GameBoardWidgetState extends State<GameBoardWidget> {
  late final GameBoard _gameBoard = GameBoard(widget.gameState, userId);
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

class GameBoard extends NodeWithSize {
  GameBoard(this._gameState, this.userId)
      : super(Size(
          _gameState.board.width,
          _gameState.board.height,
        )) {
    updateGameState(_gameState);
  }

  GameState _gameState;
  int userId;

  updateGameState(GameState gameState) {
    _gameState = gameState;

    // Reset the board.
    removeAllChildren();

    // Update players.
    for (var player in _gameState.players) {
      for (var blob in player.blobs) {
        var blobNode = BlobNode(
          radius: blob.body.radius,
          color: player.userId == userId ? Colors.blue : Colors.red,
        );
        blobNode.position = Offset(blob.body.x, blob.body.y);
        addChild(blobNode);
      }
    }

    // Update food.
    for (var food in _gameState.food) {
      var foodNode = FoodNode(radius: food.body.radius);
      foodNode.position = Offset(food.body.x, food.body.y);
      addChild(foodNode);
    }
  }
}
