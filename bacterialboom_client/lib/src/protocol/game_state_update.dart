/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

class GameStateUpdate extends _i1.SerializableEntity {
  GameStateUpdate({
    required this.gameId,
    required this.time,
    required this.players,
    required this.addedFood,
    required this.removedFoodIds,
  });

  factory GameStateUpdate.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return GameStateUpdate(
      gameId:
          serializationManager.deserialize<int>(jsonSerialization['gameId']),
      time: serializationManager.deserialize<double>(jsonSerialization['time']),
      players: serializationManager
          .deserialize<List<_i2.Player>>(jsonSerialization['players']),
      addedFood: serializationManager
          .deserialize<List<_i2.Food>>(jsonSerialization['addedFood']),
      removedFoodIds: serializationManager
          .deserialize<List<int>>(jsonSerialization['removedFoodIds']),
    );
  }

  int gameId;

  double time;

  List<_i2.Player> players;

  List<_i2.Food> addedFood;

  List<int> removedFoodIds;

  @override
  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'time': time,
      'players': players,
      'addedFood': addedFood,
      'removedFoodIds': removedFoodIds,
    };
  }
}
