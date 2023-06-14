import 'dart:math' as math;
import 'dart:ui';

import 'package:bacterialboom_flutter/src/game_nodes/game_board.dart';
import 'package:spritewidget/spritewidget.dart';

const _dampening = 0.95;

class GameViewNode extends NodeWithSize {
  GameViewNode(this.gameBoard) : super(const Size(1024, 1024)) {
    addChild(gameBoard);
  }

  final GameBoard gameBoard;
  Offset? _targetOffset;

  @override
  void update(double dt) {
    print('board size: ${gameBoard.size}, view size: $size');
    var playerBounds = gameBoard.playerBounds;
    var focus = playerBounds.center;

    var longestViewSide = math.max(size.width, size.height);
    var longestPlayerSide = math.max(playerBounds.width, playerBounds.height);

    var targetScale = longestViewSide / longestPlayerSide / 20;

    var viewCenter = Offset(size.width / 2, size.height / 2);
    var targetOffset = viewCenter - focus * targetScale;

    if (_targetOffset == null) {
      // Initially set the position without dampening.
      _targetOffset = targetOffset;
      gameBoard.position = _targetOffset!;
      gameBoard.scale = targetScale;
    } else {
      // Dampen the position.
      if (gameBoard.isAlive) {
        // Follow the player as long as it is alive.
        _targetOffset = targetOffset;
      }
      var timeAdjustedDampening =
          (1 - math.pow(1 - _dampening, dt * 60)).toDouble();

      gameBoard.position = gameBoard.position * timeAdjustedDampening +
          _targetOffset! * (1 - timeAdjustedDampening);

      gameBoard.scale = gameBoard.scale * timeAdjustedDampening +
          targetScale * (1 - timeAdjustedDampening);
    }

    // Make sure the game board is not outside the view.
  }
}
