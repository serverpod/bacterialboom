import 'dart:math';

import 'package:bacterialboom_server/src/extensions/blob.dart';
import 'package:bacterialboom_server/src/generated/protocol.dart';
import 'package:bacterialboom_server/src/util/offset.dart';

extension PlayerExtension on Player {
  static Player create(int userId, GameState game) {
    var random = Random();
    var player = Player(
      name: '$userId',
      userId: userId,
      blobs: [
        BlobExtension.create(
          position: Offset(
            random.nextDouble() * game.board.width,
            random.nextDouble() * game.board.height,
          ),
        ),
      ],
    );

    game.players.add(player);

    return player;
  }

  Offset get center {
    var x = 0.0;
    var y = 0.0;
    for (var blob in blobs) {
      x += blob.body.x;
      y += blob.body.y;
    }
    x /= blobs.length;
    y /= blobs.length;
    return Offset(x, y);
  }

  double get averageBlobRadius {
    if (blobs.isEmpty) return 0.0;

    var radius = 0.0;
    for (var blob in blobs) {
      radius += blob.body.radius;
    }
    return radius / blobs.length;
  }
}
