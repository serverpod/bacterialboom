/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

class GameState extends _i1.SerializableEntity {
  GameState({
    required this.gameId,
    required this.board,
    required this.food,
    required this.players,
  });

  factory GameState.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return GameState(
      gameId:
          serializationManager.deserialize<int>(jsonSerialization['gameId']),
      board: serializationManager
          .deserialize<_i2.Board>(jsonSerialization['board']),
      food: serializationManager
          .deserialize<List<_i2.Food>>(jsonSerialization['food']),
      players: serializationManager
          .deserialize<List<_i2.Player>>(jsonSerialization['players']),
    );
  }

  int gameId;

  _i2.Board board;

  List<_i2.Food> food;

  List<_i2.Player> players;

  @override
  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'board': board,
      'food': food,
      'players': players,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'gameId': gameId,
      'board': board,
      'food': food,
      'players': players,
    };
  }
}
