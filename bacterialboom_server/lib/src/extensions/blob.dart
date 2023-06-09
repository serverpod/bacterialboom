import 'dart:math';

import 'package:bacterialboom_server/src/generated/protocol.dart';
import 'package:bacterialboom_server/src/extensions/body.dart';
import 'package:bacterialboom_server/src/util/offset.dart';

const defaultBlobRadius = 10.0;

// Larger blobs are slower.
double _velocityForArea(double area) => 1000 / area;

extension BlobExtension on Blob {
  static int _blobId = 0;

  static Blob create({
    required Offset position,
    double radius = defaultBlobRadius,
  }) {
    var blob = Blob(
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
    var angle = atan2(
      target.y - body.y,
      target.x - body.x,
    );

    if (reverse) {
      angle += pi;
    }

    body.x += cos(angle) * maxVelocity;
    body.y += sin(angle) * maxVelocity;

    body.constrainPosition(game);
  }
}
