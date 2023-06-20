import 'dart:math';

import 'package:bacterialboom_server/src/generated/protocol.dart';
import 'package:bacterialboom_server/src/extensions/body.dart';
import 'package:bacterialboom_server/src/extensions/game_state.dart';
import 'package:bacterialboom_server/src/util/distance.dart';
import 'package:bacterialboom_server/src/util/offset.dart';

const defaultBlobRadius = 5.0;
const minimumBlobRadius = 5.0;
const minimumBlobArea = minimumBlobRadius * minimumBlobRadius * pi;
const _shrinkFactor = 0.95;

// Larger blobs are slower.
double _velocityForArea(double area) => 5000 / area;

extension BlobExtension on Blob {
  static int _blobId = 0;

  static Blob create({
    required int userId,
    required Offset position,
    double radius = defaultBlobRadius,
  }) {
    var blob = Blob(
      userId: userId,
      body: Body(
        x: position.x,
        y: position.y,
        radius: radius,
      ),
      blobId: _blobId++,
      maxVelocity: 0.0,
    );
    blob.updateMaxVelocity();

    return blob;
  }

  double get area => body.area;

  set area(double area) {
    body.area = area;
    updateMaxVelocity();
  }

  void updateMaxVelocity() {
    maxVelocity = _velocityForArea(body.area);
  }

  void moveTowardsTarget(
    Offset target,
    GameState game, {
    bool reverse = false,
  }) {
    // Update target.
    xTarget = target.x;
    yTarget = target.y;

    var angle = atan2(
      target.y - body.y,
      target.x - body.x,
    );

    if (reverse) {
      angle += pi;
    }

    var moveDistance = maxVelocity * GameStateExtension.deltaTime;

    if (approximateDistance(target, body.position) < moveDistance) {
      // We reached the target. Reset so that we will look for another one.
      body.position = target;
      xTarget = null;
      yTarget = null;
    } else {
      body.x += cos(angle) * moveDistance;
      body.y += sin(angle) * moveDistance;
    }

    body.constrainPosition(game);
  }

  void shrink() {
    if (body.radius > minimumBlobRadius) {
      area = area * pow(_shrinkFactor, GameStateExtension.deltaTime);
    }

    if (body.radius < minimumBlobRadius) {
      body.radius = minimumBlobRadius;
    }

    updateMaxVelocity();
  }

  bool get canSplit => area >= minimumBlobArea * 2;

  Offset? get target {
    if (xTarget != null && yTarget != null) {
      return Offset(xTarget!, yTarget!);
    } else {
      return null;
    }
  }
}
