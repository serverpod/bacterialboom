import 'dart:math';

import 'package:bacterialboom_server/src/generated/body.dart';
import 'package:bacterialboom_server/src/generated/game_state.dart';
import 'package:bacterialboom_server/src/util/distance.dart';
import 'package:bacterialboom_server/src/util/offset.dart';

extension BodyExtension on Body {
  Offset get position => Offset(x, y);

  double get area => radius * radius * pi;

  set area(double area) {
    radius = sqrt(area / pi);
  }

  bool collidesWith(Body other) {
    var distance = approximateDistance(position, other.position);
    return distance < radius + other.radius;
  }

  void constrainPosition(GameState game) {
    if (x < radius) {
      x = radius;
    } else if (x > game.board.width - radius) {
      x = game.board.width - radius;
    }
    if (y < radius) {
      y = radius;
    } else if (y > game.board.height - radius) {
      y = game.board.height - radius;
    }
  }
}
