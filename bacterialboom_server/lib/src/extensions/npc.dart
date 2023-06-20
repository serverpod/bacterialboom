import 'dart:math';

import 'package:bacterialboom_server/src/extensions/blob.dart';
import 'package:bacterialboom_server/src/extensions/body.dart';
import 'package:bacterialboom_server/src/extensions/game_state.dart';
import 'package:bacterialboom_server/src/extensions/player.dart';
import 'package:bacterialboom_server/src/generated/protocol.dart';
import 'package:bacterialboom_server/src/logic/collisions.dart';
import 'package:bacterialboom_server/src/util/offset.dart';

const _npcSearchDistance = 100.0;
const _splitProbability = 0.1;
const _findNewTargetProbability = 0.05;

extension NpcExtension on Player {
  static int _npcId = -1;

  static Player create({
    required GameState game,
  }) {
    var random = Random();
    var npc = Player(
      name: 'NPC',
      userId: _npcId,
      spawnedAt: game.time,
      score: 0,
      colorIdx: game.nextColorIdx,
      blobs: [
        BlobExtension.create(
          userId: _npcId,
          position: Offset(
            random.nextDouble() * game.board.width,
            random.nextDouble() * game.board.height,
          ),
          radius: defaultBlobRadius,
        ),
      ],
    );

    game.players.add(npc);
    game.nextColorIdx = (game.nextColorIdx + 1) % numPlayerColorIndices;

    _npcId -= 1;
    return npc;
  }

  bool get isNpc => userId < 0;

  void tickNpc(GameState game, CollisionHandler collisionHandler) {
    assert(userId < 0, 'Only NPCs can call this method.');

    var random = Random();

    if (blobs.isEmpty) {
      // NPC is dead.
      return;
    }

    bool allBlobsHaveTargets = true;
    for (var blob in blobs) {
      if (blob.xTarget == null || blob.yTarget == null) {
        allBlobsHaveTargets = false;
        break;
      }
    }

    Offset? target;

    if (allBlobsHaveTargets &&
        random.nextDouble() >= _findNewTargetProbability) {
      // Continue moving towards last target.
      target = blobs.first.target!;
    } else {
      // Find new target.

      var closestBlob = collisionHandler.closestBlobWithinDistance(
        position: center,
        maxDistance: _npcSearchDistance,
        excludeUserId: userId,
      );

      if (closestBlob != null) {
        if (closestBlob.body.radius >= averageBlobRadius) {
          // Run away from opponent.
          var dx = closestBlob.body.x - center.x;
          var dy = closestBlob.body.y - center.y;

          target = Offset(
            center.x - dx,
            center.y - dy,
          );
        } else {
          // Chase opponent.
          target = closestBlob.body.position;
        }
      } else {
        // Find food.
        var closestFood = collisionHandler.closestFoodWithinDistance(
          position: center,
          maxDistance: _npcSearchDistance,
        );

        if (closestFood != null) {
          target = closestFood.body.position;
        }
      }
    }

    if (target != null) {
      for (var blob in blobs) {
        blob.moveTowardsTarget(
          target,
          game,
        );
      }
    }

    if (canSplit &&
        random.nextDouble() <
            _splitProbability * GameStateExtension.deltaTime) {
      splitBlobs(game);
    }

    avoidOverlappingBlobs();
  }
}
