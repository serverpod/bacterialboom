/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

class Obstacle extends _i1.SerializableEntity {
  Obstacle({
    required this.obstacleId,
    required this.body,
  });

  factory Obstacle.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Obstacle(
      obstacleId: serializationManager
          .deserialize<int>(jsonSerialization['obstacleId']),
      body:
          serializationManager.deserialize<_i2.Body>(jsonSerialization['body']),
    );
  }

  int obstacleId;

  _i2.Body body;

  @override
  Map<String, dynamic> toJson() {
    return {
      'obstacleId': obstacleId,
      'body': body,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'obstacleId': obstacleId,
      'body': body,
    };
  }
}
