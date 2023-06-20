/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

class Blob extends _i1.SerializableEntity {
  Blob({
    required this.userId,
    required this.blobId,
    required this.body,
    required this.maxVelocity,
    this.xTarget,
    this.yTarget,
  });

  factory Blob.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Blob(
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      blobId:
          serializationManager.deserialize<int>(jsonSerialization['blobId']),
      body:
          serializationManager.deserialize<_i2.Body>(jsonSerialization['body']),
      maxVelocity: serializationManager
          .deserialize<double>(jsonSerialization['maxVelocity']),
      xTarget: serializationManager
          .deserialize<double?>(jsonSerialization['xTarget']),
      yTarget: serializationManager
          .deserialize<double?>(jsonSerialization['yTarget']),
    );
  }

  int userId;

  int blobId;

  _i2.Body body;

  double maxVelocity;

  double? xTarget;

  double? yTarget;

  @override
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'blobId': blobId,
      'body': body,
      'maxVelocity': maxVelocity,
      'xTarget': xTarget,
      'yTarget': yTarget,
    };
  }
}
