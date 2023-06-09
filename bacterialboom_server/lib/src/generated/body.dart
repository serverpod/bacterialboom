/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class Body extends _i1.SerializableEntity {
  Body({
    required this.x,
    required this.y,
    required this.radius,
  });

  factory Body.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Body(
      x: serializationManager.deserialize<double>(jsonSerialization['x']),
      y: serializationManager.deserialize<double>(jsonSerialization['y']),
      radius:
          serializationManager.deserialize<double>(jsonSerialization['radius']),
    );
  }

  double x;

  double y;

  double radius;

  @override
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'radius': radius,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'x': x,
      'y': y,
      'radius': radius,
    };
  }
}
