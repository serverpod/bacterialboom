/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

class Blob extends _i1.SerializableEntity {
  Blob({
    required this.blobId,
    required this.body,
    required this.maxVelocity,
  });

  factory Blob.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Blob(
      blobId:
          serializationManager.deserialize<int>(jsonSerialization['blobId']),
      body:
          serializationManager.deserialize<_i2.Body>(jsonSerialization['body']),
      maxVelocity: serializationManager
          .deserialize<double>(jsonSerialization['maxVelocity']),
    );
  }

  int blobId;

  _i2.Body body;

  double maxVelocity;

  @override
  Map<String, dynamic> toJson() {
    return {
      'blobId': blobId,
      'body': body,
      'maxVelocity': maxVelocity,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'blobId': blobId,
      'body': body,
      'maxVelocity': maxVelocity,
    };
  }
}
