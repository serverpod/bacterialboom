import 'dart:math';

import 'package:bacterialboom_server/src/extensions/blob.dart';
import 'package:bacterialboom_server/src/extensions/body.dart';
import 'package:bacterialboom_server/src/generated/protocol.dart';
import 'package:bacterialboom_server/src/util/distance.dart';
import 'package:bacterialboom_server/src/util/offset.dart';

extension PlayerExtension on Player {
  static Player create(int userId, GameState game) {
    var random = Random();
    var player = Player(
      name: '$userId',
      userId: userId,
      spawnedAt: game.time,
      blobs: [
        BlobExtension.create(
          position: Offset(
            random.nextDouble() * game.board.width,
            random.nextDouble() * game.board.height,
          ),
        ),
      ],
    );

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

  void shrinkBlobs() {
    for (var blob in blobs) {
      blob.shrink();
    }
  }

  bool get canSplit {
    for (var blob in blobs) {
      if (blob.canSplit) return true;
    }
    return false;
  }

  void splitBlobs(GameState game) {
    var newBlobs = <Blob>[];
    for (var blob in blobs) {
      if (blob.canSplit) {
        var splitArea = blob.area / 2;
        var splitRadius = sqrt(splitArea / pi);

        blob.area = splitArea;
        var angle = Random().nextDouble() * 2 * pi;
        var offset = Offset(
          cos(angle) * splitRadius * 2,
          sin(angle) * splitRadius * 2,
        );
        blob.body.position = blob.body.position + offset;

        var newBlob = BlobExtension.create(
          position: blob.body.position - offset,
          radius: splitRadius,
        );
        newBlobs.add(newBlob);
      }
    }
    blobs.addAll(newBlobs);
    splittedAt = game.time;
  }

  void joinBlobs(GameState game) {
    splittedAt = null;
    if (blobs.length <= 1) return;

    var joinedBlobPosition = center;

    var joinedBlob = blobs.first;
    double totalArea = 0.0;
    for (var blob in blobs) {
      totalArea += blob.area;
    }

    joinedBlob.area = totalArea;
    joinedBlob.body.position = joinedBlobPosition;
    blobs.removeWhere((e) => e != joinedBlob);
  }

  void avoidOverlappingBlobs() {
    for (var blob in blobs) {
      for (var otherBlob in blobs) {
        if (blob == otherBlob) continue;

        var distance = approximateDistance(
          blob.body.position,
          otherBlob.body.position,
        );
        if (distance < 0.1) {
          distance = 0.1;
        }
        var overlap = blob.body.radius + otherBlob.body.radius - distance;
        if (overlap > 0) {
          var direction = blob.body.position - otherBlob.body.position;
          direction = direction / distance;
          blob.body.position += direction * overlap / 2;
          otherBlob.body.position -= direction * overlap / 2;
        }
      }
    }
  }

  double getLifeTime(GameState game) => game.time - spawnedAt;
}
