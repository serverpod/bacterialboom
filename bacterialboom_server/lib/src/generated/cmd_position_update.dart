/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

class CmdPositionUpdate extends _i1.SerializableEntity {
  CmdPositionUpdate({required this.blobs});

  factory CmdPositionUpdate.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return CmdPositionUpdate(
        blobs: serializationManager
            .deserialize<List<_i2.Blob>>(jsonSerialization['blobs']));
  }

  List<_i2.Blob> blobs;

  @override
  Map<String, dynamic> toJson() {
    return {'blobs': blobs};
  }

  @override
  Map<String, dynamic> allToJson() {
    return {'blobs': blobs};
  }
}
