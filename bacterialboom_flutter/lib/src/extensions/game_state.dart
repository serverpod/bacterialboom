import 'package:bacterialboom_client/bacterialboom_client.dart';

extension GameStateExtension on GameState {
  void update(GameStateUpdate update) {
    assert(update.gameId == gameId);
    players = update.players;
    time = update.time;

    food.removeWhere((e) => update.removedFoodIds.contains(e.foodId));
    for (var addedFood in update.addedFood) {
      food.add(addedFood);
    }
  }
}
