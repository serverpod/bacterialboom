import 'package:bacterialboom_server/src/extensions/body.dart';
import 'package:bacterialboom_server/src/extensions/game_state.dart';
import 'package:bacterialboom_server/src/generated/protocol.dart';
import 'package:bacterialboom_server/src/util/distance.dart';
import 'package:bacterialboom_server/src/util/offset.dart';
import 'package:quadtree_dart/quadtree_dart.dart';

class CollisionHandler {
  CollisionHandler({
    required this.blobs,
    required this.food,
  }) {
    // Build quad tree for blobs.
    _blobsQuadTree = Quadtree(
      Rect(
        x: 0,
        y: 0,
        width: GameStateExtension.boardWidth,
        height: GameStateExtension.boardHeight,
      ),
    );
    for (var b in blobs) {
      _blobsQuadTree.insert(BlobRect(b));
    }

    // Build quad tree for food.
    _foodQuadTree = Quadtree(
      Rect(
        x: 0,
        y: 0,
        width: GameStateExtension.boardWidth,
        height: GameStateExtension.boardHeight,
      ),
    );
    for (var f in food) {
      _foodQuadTree.insert(FoodRect(f));
    }
  }

  final List<Blob> blobs;
  final List<Food> food;

  late final Quadtree _blobsQuadTree;
  late final Quadtree _foodQuadTree;

  List<Blob> collidesWithBlob(Body body) {
    var potentialHits = _blobsQuadTree.retrieve(body.bounds);
    var hits = <Blob>[];
    for (var potentialHit in potentialHits) {
      if (potentialHit is BlobRect &&
          potentialHit.blob.body != body &&
          potentialHit.blob.body.collidesWith(body)) {
        hits.add(potentialHit.blob);
      }
    }
    return hits;
  }

  List<Food> collidesWithFood(Body body) {
    var potentialHits = _foodQuadTree.retrieve(body.bounds);
    var hits = <Food>[];
    for (var potentialHit in potentialHits) {
      if (potentialHit is FoodRect &&
          potentialHit.food.body.collidesWith(body)) {
        hits.add(potentialHit.food);
      }
    }
    return hits;
  }

  Blob? closestBlobWithinDistance({
    required Offset position,
    required double maxDistance,
    required int excludeUserId,
  }) {
    var potentialBlobs = _blobsQuadTree.retrieve(
      Rect(
        x: position.x - maxDistance,
        y: position.y - maxDistance,
        width: maxDistance * 2,
        height: maxDistance * 2,
      ),
    );

    Blob? closestBlob;
    var closestDistance = double.infinity;
    for (var potentialBlob in potentialBlobs) {
      if (potentialBlob is BlobRect) {
        var distance = approximateDistance(
          position,
          potentialBlob.blob.body.position,
        );
        if (distance < closestDistance &&
            distance < maxDistance &&
            potentialBlob.blob.userId != excludeUserId) {
          closestBlob = potentialBlob.blob;
          closestDistance = distance;
        }
      }
    }

    return closestBlob;
  }

  Food? closestFoodWithinDistance({
    required Offset position,
    required double maxDistance,
  }) {
    var potentialFood = _foodQuadTree.retrieve(
      Rect(
        x: position.x - maxDistance,
        y: position.y - maxDistance,
        width: maxDistance * 2,
        height: maxDistance * 2,
      ),
    );

    Food? closestFood;
    var closestDistance = double.infinity;
    for (var potentialFood in potentialFood) {
      if (potentialFood is FoodRect) {
        var distance = approximateDistance(
          position,
          potentialFood.food.body.position,
        );
        if (distance < closestDistance && distance < maxDistance) {
          closestFood = potentialFood.food;
          closestDistance = distance;
        }
      }
    }

    return closestFood;
  }
}

class BlobRect extends Rect {
  BlobRect(this.blob)
      : super(
          x: blob.body.x - blob.body.radius,
          y: blob.body.y - blob.body.radius,
          width: blob.body.radius * 2,
          height: blob.body.radius * 2,
        );
  final Blob blob;
}

class FoodRect extends Rect {
  FoodRect(this.food)
      : super(
          x: food.body.x - food.body.radius,
          y: food.body.y - food.body.radius,
          width: food.body.radius * 2,
          height: food.body.radius * 2,
        );
  final Food food;
}

extension _BodyBounds on Body {
  Rect get bounds => Rect(
        x: x - radius,
        y: y - radius,
        width: radius * 2,
        height: radius * 2,
      );
}
