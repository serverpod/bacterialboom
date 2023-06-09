import 'dart:math';

import 'package:bacterialboom_server/src/generated/protocol.dart';

const _defaultFoodRadius = 2.0;

extension FoodExtension on Food {
  static int _foodId = 0;

  static Food create(GameState game) {
    var random = Random();

    var food = Food(
      body: Body(
        x: random.nextDouble() * game.board.width,
        y: random.nextDouble() * game.board.height,
        radius: _defaultFoodRadius,
      ),
      foodId: _foodId++,
    );

    game.food.add(food);

    return food;
  }
}
