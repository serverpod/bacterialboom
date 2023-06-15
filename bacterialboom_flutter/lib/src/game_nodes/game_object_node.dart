import 'dart:ui';

import 'package:bacterialboom_flutter/src/game_nodes/game_board.dart';
import 'package:bacterialboom_flutter/src/game_nodes/game_view.dart';
import 'package:spritewidget/spritewidget.dart';

class GameObjectNode extends Node {
  bool isInViewFrame(double radius) {
    var gameNode = parent as GameBoard;
    var gameView = gameNode.parent as GameViewNode;

    var globalPosition = convertPointToBoxSpace(Offset.zero);
    var globalScale = gameNode.scale;

    return (globalPosition.dx > -radius * globalScale &&
        globalPosition.dx < gameView.size.width + radius * globalScale &&
        globalPosition.dy > -radius * globalScale &&
        globalPosition.dy < gameView.size.height + radius * globalScale);
  }
}
