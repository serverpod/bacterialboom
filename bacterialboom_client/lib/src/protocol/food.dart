/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

class Food extends _i1.SerializableEntity {
  Food({
    required this.foodId,
    required this.body,
  });

  factory Food.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Food(
      foodId:
          serializationManager.deserialize<int>(jsonSerialization['foodId']),
      body:
          serializationManager.deserialize<_i2.Body>(jsonSerialization['body']),
    );
  }

  int foodId;

  _i2.Body body;

  @override
  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'body': body,
    };
  }
}
