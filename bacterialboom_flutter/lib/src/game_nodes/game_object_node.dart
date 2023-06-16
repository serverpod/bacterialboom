import 'dart:ui';

import 'package:bacterialboom_flutter/src/game_nodes/game_board.dart';
import 'package:bacterialboom_flutter/src/game_nodes/game_view.dart';
import 'package:spritewidget/spritewidget.dart';

class GameObjectNode extends Node {
  GameViewNode get gameView {
    var p = parent;
    while (p is! GameViewNode) {
      p = p!.parent;
    }
    return p;
  }

  GameBoard get gameBoard {
    var p = parent;
    while (p is! GameBoard) {
      p = p!.parent;
    }
    return p;
  }

  Rect get viewFrame {
    var topLeft = convertPointFromNode(
      Offset.zero,
      gameView,
    );

    var bottomRight = convertPointFromNode(
      Offset(gameView.size.width, gameView.size.height),
      gameView,
    );

    return Rect.fromPoints(topLeft, bottomRight);
  }

  bool isInViewFrame(double radius) {
    // TODO: Use the viewFrame property instead.

    var globalPosition = convertPointToBoxSpace(Offset.zero);
    var globalScale = gameBoard.scale;

    return (globalPosition.dx > -radius * globalScale &&
        globalPosition.dx < gameView.size.width + radius * globalScale &&
        globalPosition.dy > -radius * globalScale &&
        globalPosition.dy < gameView.size.height + radius * globalScale);
  }

  Size get gameBoardSize {
    var gameNode = parent as GameBoard;
    return gameNode.size;
  }
}
