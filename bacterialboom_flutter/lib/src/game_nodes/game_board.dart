import 'package:bacterialboom_client/bacterialboom_client.dart';
import 'package:bacterialboom_flutter/main.dart';
import 'package:bacterialboom_flutter/src/extensions/offset.dart';
import 'package:bacterialboom_flutter/src/game_nodes/background_node.dart';
import 'package:bacterialboom_flutter/src/game_nodes/blob_node.dart';
import 'package:bacterialboom_flutter/src/game_nodes/food_node.dart';
import 'package:bacterialboom_flutter/src/util.dart/distance.dart';
import 'package:bacterialboom_flutter/src/widgets/game_controls.dart';
import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

class GameBoard extends NodeWithSize {
  GameBoard({
    required this.gameState,
    required this.inputController,
    required this.userId,
  }) : super(Size(
          gameState.board.width,
          gameState.board.height,
        )) {
    updateGameState(gameState);
    inputController.onPerformAction = _onPerformAction;

    var background = BackgroundParticlesNode();
    addChild(background);
  }

  GameState gameState;
  final GameInputController inputController;
  int userId;

  bool _sentCmdSplit = false;

  @override
  void update(double dt) {
    if (isAlive) {
      var input = inputController.joystickValue.cappedNormalized;

      var playerBlobs = _blobNodesForUserId(userId);
      for (var blob in playerBlobs) {
        blob.position += input * dt * blob.maxVelocity;
        blob.constrainPosition();
      }
      _avoidOverlappingBlobNodes(playerBlobs);

      _sendPlayerPosition(playerBlobs);
    }
  }

  DateTime? _lastPlayerPositionSent;

  void _onPerformAction() {
    if (isAlive) {
      client.gameBoard.sendStreamMessage(CmdSplit(split: true));
      _sentCmdSplit = true;
    }
  }

  void _sendPlayerPosition(List<BlobNode> blobNodes) {
    if (_sentCmdSplit) {
      return;
    }

    var now = DateTime.now();
    if (_lastPlayerPositionSent == null ||
        now.difference(_lastPlayerPositionSent!) >
            Duration(milliseconds: (gameState.deltaTime * 1000).round())) {
      _lastPlayerPositionSent = now;

      var blobs = <Blob>[];
      for (var blobNode in blobNodes) {
        blobs.add(
          Blob(
            blobId: blobNode.blobId,
            body: Body(
              x: blobNode.position.dx,
              y: blobNode.position.dy,
              radius: blobNode.radius,
            ),
            maxVelocity: blobNode.maxVelocity,
          ),
        );
      }

      var positionUpdate = CmdPositionUpdate(
        blobs: blobs,
      );

      client.gameBoard.sendStreamMessage(positionUpdate);
    }
  }

  bool get isAlive =>
      gameState.players.any((player) => player.userId == userId);

  updateGameState(GameState gameState) {
    this.gameState = gameState;

    // Reset all move animations.
    motions.stopAll();

    // Make a list of all blobs ids in the update.
    var blobsInUpdate = <int>{};
    for (var player in gameState.players) {
      for (var blob in player.blobs) {
        blobsInUpdate.add(blob.blobId);
      }
    }

    // Make a map of all blobs that are on the current board.
    var blobsOnBoard = <int, BlobNode>{};
    for (var child in children) {
      if (child is BlobNode) {
        blobsOnBoard[child.blobId] = child;
      }
    }

    // Remove blobs that are not in the update.
    var blobsToRemove = <BlobNode>[];
    for (var child in children) {
      if (child is BlobNode) {
        if (!blobsInUpdate.contains(child.blobId)) {
          blobsToRemove.add(child);
        }
      }
    }

    for (var blob in blobsToRemove) {
      blob.removeFromParent();
    }

    // Update or add blobs.
    for (var player in gameState.players) {
      var isCurrentPlayer = player.userId == userId;

      for (var blob in player.blobs) {
        if (blobsOnBoard.containsKey(blob.blobId)) {
          // Update blob.
          var blobNode = blobsOnBoard[blob.blobId]!;
          blobNode.maxVelocity = blob.maxVelocity;

          // Tween radius.
          blobNode.motions.stopAll();
          blobNode.motions.run(
            MotionTween(
              setter: (double a) => blobNode.radius = a,
              start: blobNode.radius,
              end: blob.body.radius,
              duration: gameState.deltaTime,
            ),
          );

          blobNode.colorIdx = player.colorIdx;

          if (_blobNodesForUserId(userId).length != player.blobs.length) {
            // The number of blobs for the player has changed. Update the
            // position immediately.
            blobNode.position = Offset(blob.body.x, blob.body.y);
          } else if (!isCurrentPlayer) {
            // Animate to new position.
            motions.run(
              MotionTween(
                setter: (Offset a) => blobNode.position = a,
                start: blobNode.position,
                end: Offset(blob.body.x, blob.body.y),
                duration: gameState.deltaTime,
              ),
            );
          }
        } else {
          // Add blob.
          var blobNode = BlobNode(
            userId: player.userId,
            blobId: blob.blobId,
            maxVelocity: blob.maxVelocity,
            radius: blob.body.radius,
            colorIdx: player.colorIdx,
          );
          blobNode.position = Offset(blob.body.x, blob.body.y);
          addChild(blobNode);
        }
      }
    }

    // Make a list of all food ids in the update.
    var foodInUpdate = <int>{};
    for (var food in gameState.food) {
      foodInUpdate.add(food.foodId);
    }

    // Remove food that are not in the update.
    var foodToRemove = <FoodNode>[];
    for (var child in children) {
      if (child is FoodNode) {
        if (!foodInUpdate.contains(child.foodId)) {
          foodToRemove.add(child);
        }
      }
    }

    for (var food in foodToRemove) {
      food.removeFromParent();
    }

    // Make a map of all food that are on the current board.
    var foodOnBoard = <int, FoodNode>{};
    for (var child in children) {
      if (child is FoodNode) {
        foodOnBoard[child.foodId] = child;
      }
    }

    for (var food in gameState.food) {
      if (!foodOnBoard.containsKey(food.foodId)) {
        var foodNode = FoodNode(
          foodId: food.foodId,
          radius: food.body.radius,
        );
        foodNode.position = Offset(food.body.x, food.body.y);
        addChild(foodNode);
      }
    }

    _sentCmdSplit = false;
  }

  List<BlobNode> _blobNodesForUserId(int userId) {
    var blobs = <BlobNode>[];
    for (var child in children) {
      if (child is BlobNode) {
        if (child.userId == userId) {
          blobs.add(child);
        }
      }
    }
    return blobs;
  }

  Offset get playerCenter {
    var blobs = _blobNodesForUserId(userId);
    if (blobs.isEmpty) {
      return Offset.zero;
    }

    var center = Offset.zero;
    for (var blob in blobs) {
      center += blob.position;
    }
    center = center / blobs.length.toDouble();
    return center;
  }

  Rect get playerBounds {
    var blobs = _blobNodesForUserId(userId);
    if (blobs.isEmpty) {
      return Rect.zero;
    }

    Rect? bounds;
    for (var blob in blobs) {
      var blobBounds = Rect.fromCircle(
        center: blob.position,
        radius: blob.radius,
      );
      if (bounds == null) {
        bounds = blobBounds;
      } else {
        bounds = bounds.expandToInclude(blobBounds);
      }
    }
    return bounds!;
  }

  void _avoidOverlappingBlobNodes(List<BlobNode> blobs) {
    for (var blob in blobs) {
      for (var otherBlob in blobs) {
        if (blob == otherBlob) continue;

        var distance = approximateDistance(
          blob.position,
          otherBlob.position,
        );
        if (distance < 0.1) {
          distance = 0.1;
        }
        var overlap = blob.radius + otherBlob.radius - distance;
        if (overlap > 0) {
          var direction = blob.position - otherBlob.position;
          direction = direction / distance;
          blob.position += direction * overlap / 2;
          otherBlob.position -= direction * overlap / 2;
        }
      }
    }
  }
}
