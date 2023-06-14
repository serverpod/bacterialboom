import 'dart:math';

import 'package:bacterialboom_server/src/extensions/blob.dart';
import 'package:bacterialboom_server/src/extensions/body.dart';
import 'package:bacterialboom_server/src/extensions/game_state.dart';
import 'package:bacterialboom_server/src/extensions/player.dart';
import 'package:bacterialboom_server/src/generated/protocol.dart';
import 'package:bacterialboom_server/src/util/distance.dart';
import 'package:bacterialboom_server/src/util/offset.dart';

const _chaseBlobDistance = 100.0;
const _splitProbability = 0.1;

extension NpcExtension on Player {
  static int _npcId = -1;

  static Player create({
    required GameState game,
  }) {
    var random = Random();
    var npc = Player(
      name: 'NPC',
      userId: _npcId--,
      spawnedAt: game.time,
      score: 0,
      colorIdx: game.nextColorIdx,
      blobs: [
        BlobExtension.create(
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

    return npc;
  }

  bool get isNpc => userId < 0;

  void tickNpc(GameState game) {
    assert(userId < 0, 'Only NPCs can call this method.');

    var closestBlob = _findClosestOpponentBlob(
      game: game,
    );

    bool chaisingBlobs = false;

    if (closestBlob != null) {
      var distance = approximateDistance(center, closestBlob.body.position);
      if (distance < _chaseBlobDistance) {
        chaisingBlobs = true;

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
      }
    }

    if (!chaisingBlobs) {
      var closestFood = _findClosestFood(
        game: game,
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

  Blob? _findClosestOpponentBlob({
    required GameState game,
  }) {
    Blob? closestBlob;
    double closestDistance = double.infinity;
    for (var opponent in game.players) {
      if (opponent.userId == userId) continue;

      for (var blob in opponent.blobs) {
        var distance = approximateDistance(
          blob.body.position,
          center,
        );
        if (distance < closestDistance) {
          closestDistance = distance;
          closestBlob = blob;
        }
      }
    }

    return closestBlob;
  }

  Food? _findClosestFood({
    required GameState game,
  }) {
    Food? closestFood;
    double closestDistance = double.infinity;
    for (var food in game.food) {
      var distance = approximateDistance(
        food.body.position,
        center,
      );
      if (distance < closestDistance) {
        closestDistance = distance;
        closestFood = food;
      }
    }

    return closestFood;
  }
}
