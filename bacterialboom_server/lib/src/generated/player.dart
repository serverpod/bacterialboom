/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

class Player extends _i1.SerializableEntity {
  Player({
    required this.userId,
    required this.name,
    required this.blobs,
  });

  factory Player.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Player(
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      blobs: serializationManager
          .deserialize<List<_i2.Blob>>(jsonSerialization['blobs']),
    );
  }

  int userId;

  String name;

  List<_i2.Blob> blobs;

  @override
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'blobs': blobs,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'userId': userId,
      'name': name,
      'blobs': blobs,
    };
  }
}
