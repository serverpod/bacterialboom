/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_server/module.dart' as _i3;
import 'blob.dart' as _i4;
import 'board.dart' as _i5;
import 'body.dart' as _i6;
import 'food.dart' as _i7;
import 'game_state.dart' as _i8;
import 'obstacle.dart' as _i9;
import 'player.dart' as _i10;
import 'protocol.dart' as _i11;
export 'blob.dart';
export 'board.dart';
export 'body.dart';
export 'food.dart';
export 'game_state.dart';
export 'obstacle.dart';
export 'player.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Map<Type, _i1.constructor> customConstructors = {};

  static final Protocol _instance = Protocol._();

  static final targetDatabaseDefinition = _i2.DatabaseDefinition(tables: [
    ..._i3.Protocol.targetDatabaseDefinition.tables,
    ..._i2.Protocol.targetDatabaseDefinition.tables,
  ]);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (customConstructors.containsKey(t)) {
      return customConstructors[t]!(data, this) as T;
    }
    if (t == _i4.Blob) {
      return _i4.Blob.fromJson(data, this) as T;
    }
    if (t == _i5.Board) {
      return _i5.Board.fromJson(data, this) as T;
    }
    if (t == _i6.Body) {
      return _i6.Body.fromJson(data, this) as T;
    }
    if (t == _i7.Food) {
      return _i7.Food.fromJson(data, this) as T;
    }
    if (t == _i8.GameState) {
      return _i8.GameState.fromJson(data, this) as T;
    }
    if (t == _i9.Obstacle) {
      return _i9.Obstacle.fromJson(data, this) as T;
    }
    if (t == _i10.Player) {
      return _i10.Player.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i4.Blob?>()) {
      return (data != null ? _i4.Blob.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i5.Board?>()) {
      return (data != null ? _i5.Board.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i6.Body?>()) {
      return (data != null ? _i6.Body.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i7.Food?>()) {
      return (data != null ? _i7.Food.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i8.GameState?>()) {
      return (data != null ? _i8.GameState.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i9.Obstacle?>()) {
      return (data != null ? _i9.Obstacle.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i10.Player?>()) {
      return (data != null ? _i10.Player.fromJson(data, this) : null) as T;
    }
    if (t == List<_i11.Food>) {
      return (data as List).map((e) => deserialize<_i11.Food>(e)).toList()
          as dynamic;
    }
    if (t == List<_i11.Player>) {
      return (data as List).map((e) => deserialize<_i11.Player>(e)).toList()
          as dynamic;
    }
    if (t == List<_i11.Blob>) {
      return (data as List).map((e) => deserialize<_i11.Blob>(e)).toList()
          as dynamic;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    String? className;
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    if (data is _i4.Blob) {
      return 'Blob';
    }
    if (data is _i5.Board) {
      return 'Board';
    }
    if (data is _i6.Body) {
      return 'Body';
    }
    if (data is _i7.Food) {
      return 'Food';
    }
    if (data is _i8.GameState) {
      return 'GameState';
    }
    if (data is _i9.Obstacle) {
      return 'Obstacle';
    }
    if (data is _i10.Player) {
      return 'Player';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (data['className'] == 'Blob') {
      return deserialize<_i4.Blob>(data['data']);
    }
    if (data['className'] == 'Board') {
      return deserialize<_i5.Board>(data['data']);
    }
    if (data['className'] == 'Body') {
      return deserialize<_i6.Body>(data['data']);
    }
    if (data['className'] == 'Food') {
      return deserialize<_i7.Food>(data['data']);
    }
    if (data['className'] == 'GameState') {
      return deserialize<_i8.GameState>(data['data']);
    }
    if (data['className'] == 'Obstacle') {
      return deserialize<_i9.Obstacle>(data['data']);
    }
    if (data['className'] == 'Player') {
      return deserialize<_i10.Player>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    return null;
  }

  @override
  _i2.DatabaseDefinition getTargetDatabaseDefinition() =>
      targetDatabaseDefinition;
}
