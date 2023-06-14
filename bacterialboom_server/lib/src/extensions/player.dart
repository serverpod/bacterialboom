import 'dart:math';

import 'package:bacterialboom_server/src/extensions/blob.dart';
import 'package:bacterialboom_server/src/extensions/body.dart';
import 'package:bacterialboom_server/src/generated/protocol.dart';
import 'package:bacterialboom_server/src/util/distance.dart';
import 'package:bacterialboom_server/src/util/offset.dart';

extension PlayerExtension on Player {
  static Player create({
    required int userId,
    required String userInfo,
    required GameState game,
  }) {
    var random = Random();
    var player = Player(
      name: userInfo,
      userId: userId,
      spawnedAt: game.time,
      score: 0,
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

  double get area {
    var area = 0.0;
    for (var blob in blobs) {
      area += blob.area;
    }
    return area;
  }

  void splitBlobs(GameState game) {
    if (userId >= 0) {
      print('Splitting blobs for $name, area: $area');
    }
    var newBlobs = <Blob>[];
    for (var blob in blobs) {
      if (blob.canSplit) {
        var splitArea = blob.area / 2;
        var splitRadius = sqrt(splitArea / pi);

        blob.area = splitArea;
        var angle = Random().nextDouble() * 2 * pi;
        var offset = Offset(
          cos(angle) * splitRadius,
          sin(angle) * splitRadius,
        );

        var newBlobA = BlobExtension.create(
          position: blob.body.position - offset,
          radius: splitRadius,
        );
        newBlobs.add(newBlobA);

        var newBlobB = BlobExtension.create(
          position: blob.body.position + offset,
          radius: splitRadius,
        );
        newBlobs.add(newBlobB);
      } else {
        newBlobs.add(blob);
      }
    }
    blobs = newBlobs;
    splittedAt = game.time;

    if (userId >= 0) {
      print(' - ${blobs.length} blobs area: $area');
    }
  }

  void joinBlobs(GameState game) {
    splittedAt = null;
    if (blobs.length <= 1) return;

    if (userId >= 0) {
      print('Joining blobs for $name area: $area');
    }

    var joinedBlobPosition = center;

    // var joinedBlob = blobs.first;
    double totalArea = 0.0;
    for (var blob in blobs) {
      totalArea += blob.area;
    }

    var joinedBlob = BlobExtension.create(
      position: joinedBlobPosition,
      radius: sqrt(totalArea / pi),
    );

    blobs = [joinedBlob];

    // joinedBlob.area = totalArea;
    // joinedBlob.body.position = joinedBlobPosition;
    // blobs.removeWhere((e) => e != joinedBlob);

    if (userId >= 0) {
      print(' - ${blobs.length} blobs area: $area');
    }
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
