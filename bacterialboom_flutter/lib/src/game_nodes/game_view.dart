import 'dart:math' as math;
import 'package:bacterialboom_flutter/src/game_nodes/game_board.dart';
import 'package:bacterialboom_flutter/src/util.dart/dampening.dart';
import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

const _dampening = 3.0;

class GameViewNode extends NodeWithSize {
  GameViewNode(this.gameBoard) : super(const Size(1024, 1024)) {
    addChild(gameBoard);

    fpsDisplay = Label('');
    fpsDisplay.textStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
    fpsDisplay.position = const Offset(10, 10);
    fpsDisplay.zPosition = 100;
    addChild(fpsDisplay);
  }

  final GameBoard gameBoard;
  Offset? _targetOffset;
  double? _targetScale;

  late final Label fpsDisplay;

  @override
  void update(double dt) {
    fpsDisplay.text = dt == 0 ? '-- FPS' : '${(1 / dt).round()} FPS (dt: $dt)';

    var playerBounds = gameBoard.playerBounds;
    var focus = playerBounds.center;

    var longestViewSide = math.max(size.width, size.height);
    var longestPlayerSide = math.max(playerBounds.width, playerBounds.height);

    var minScale = longestViewSide / 20 / 20;
    var maxScale = longestViewSide / 10 / 20;
    var targetScale =
        (longestViewSide / longestPlayerSide / 10).clamp(minScale, maxScale);

    var viewCenter = Offset(size.width / 2, size.height / 2);
    var targetOffset = viewCenter - focus * targetScale;

    targetOffset = _clampOffsetToView(targetOffset, targetScale);

    if (_targetOffset == null) {
      // Initially set the position without dampening.
      _targetOffset = targetOffset;
      _targetScale = targetScale;
      gameBoard.position = _targetOffset!;
      gameBoard.scale = _targetScale!;
    } else {
      // Dampen the position.
      if (gameBoard.isAlive) {
        // Follow the player as long as it is alive.
        _targetOffset = targetOffset;
        _targetScale = targetScale;
      }

      gameBoard.position = dampenOffset(
        value: gameBoard.position,
        target: _targetOffset!,
        dampeningRatio: _dampening,
        dt: dt,
      );

      gameBoard.scale = dampen(
        value: gameBoard.scale,
        target: _targetScale!,
        dampeningRatio: _dampening,
        dt: dt,
      );
    }
  }

  Offset _clampOffsetToView(Offset targetOffset, double scale) {
    var targetOffsetX = targetOffset.dx;
    var targetOffsetY = targetOffset.dy;

    if (targetOffsetX > 0) {
      targetOffsetX = 0;
    }
    if (targetOffsetY > 0) {
      targetOffsetY = 0;
    }

    var maxOffsetX = size.width - gameBoard.size.width * scale;
    var maxOffsetY = size.height - gameBoard.size.height * scale;

    if (targetOffsetX < maxOffsetX) {
      targetOffsetX = maxOffsetX;
    }
    if (targetOffsetY < maxOffsetY) {
      targetOffsetY = maxOffsetY;
    }

    targetOffset = Offset(targetOffsetX, targetOffsetY);

    return targetOffset;
  }

  @override
  set size(Size size) {
    if (size != this.size) {
      super.size = size;
      update(0);
    }
  }
}
