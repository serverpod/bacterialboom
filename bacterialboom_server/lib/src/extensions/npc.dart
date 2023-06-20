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

    var closestBlob = collisionHandler.closestBlobWithinDistance(
      position: center,
      maxDistance: _npcSearchDistance,
      excludeUserId: userId,
    );

    if (closestBlob != null) {
      if (closestBlob.body.radius > averageBlobRadius) {
        // Run away from opponent.
        for (var blob in blobs) {
          blob.moveTowardsTarget(
            closestBlob.body.position,
            game,
            reverse: true,
          );
        }
      } else {
        // Chase opponent.
        for (var blob in blobs) {
          blob.moveTowardsTarget(
            closestBlob.body.position,
            game,
          );
        }
      }
    } else {
      var closestFood = collisionHandler.closestFoodWithinDistance(
        position: center,
        maxDistance: _npcSearchDistance,
      );

      if (closestFood != null) {
        // Chase food.
        for (var blob in blobs) {
          blob.moveTowardsTarget(
            closestFood.body.position,
            game,
          );
        }
      }
    }

    var random = Random();

    if (canSplit &&
        random.nextDouble() <
            _splitProbability * GameStateExtension.deltaTime) {
      splitBlobs(game);
    }

    avoidOverlappingBlobs();
  }
}
