/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'blob.dart' as _i2;
import 'board.dart' as _i3;
import 'body.dart' as _i4;
import 'food.dart' as _i5;
import 'game_state.dart' as _i6;
import 'obstacle.dart' as _i7;
import 'player.dart' as _i8;
import 'protocol.dart' as _i9;
import 'package:serverpod_auth_client/module.dart' as _i10;
export 'blob.dart';
export 'board.dart';
export 'body.dart';
export 'food.dart';
export 'game_state.dart';
export 'obstacle.dart';
export 'player.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Map<Type, _i1.constructor> customConstructors = {};

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (customConstructors.containsKey(t)) {
      return customConstructors[t]!(data, this) as T;
    }
    if (t == _i2.Blob) {
      return _i2.Blob.fromJson(data, this) as T;
    }
    if (t == _i3.Board) {
      return _i3.Board.fromJson(data, this) as T;
    }
    if (t == _i4.Body) {
      return _i4.Body.fromJson(data, this) as T;
    }
    if (t == _i5.Food) {
      return _i5.Food.fromJson(data, this) as T;
    }
    if (t == _i6.GameState) {
      return _i6.GameState.fromJson(data, this) as T;
    }
    if (t == _i7.Obstacle) {
      return _i7.Obstacle.fromJson(data, this) as T;
    }
    if (t == _i8.Player) {
      return _i8.Player.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i2.Blob?>()) {
      return (data != null ? _i2.Blob.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i3.Board?>()) {
      return (data != null ? _i3.Board.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i4.Body?>()) {
      return (data != null ? _i4.Body.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i5.Food?>()) {
      return (data != null ? _i5.Food.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i6.GameState?>()) {
      return (data != null ? _i6.GameState.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i7.Obstacle?>()) {
      return (data != null ? _i7.Obstacle.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i8.Player?>()) {
      return (data != null ? _i8.Player.fromJson(data, this) : null) as T;
    }
    if (t == List<_i9.Food>) {
      return (data as List).map((e) => deserialize<_i9.Food>(e)).toList()
          as dynamic;
    }
    if (t == List<_i9.Player>) {
      return (data as List).map((e) => deserialize<_i9.Player>(e)).toList()
          as dynamic;
    }
    if (t == List<_i9.Blob>) {
      return (data as List).map((e) => deserialize<_i9.Blob>(e)).toList()
          as dynamic;
    }
    try {
      return _i10.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    String? className;
    className = _i10.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    if (data is _i2.Blob) {
      return 'Blob';
    }
    if (data is _i3.Board) {
      return 'Board';
    }
    if (data is _i4.Body) {
      return 'Body';
    }
    if (data is _i5.Food) {
      return 'Food';
    }
    if (data is _i6.GameState) {
      return 'GameState';
    }
    if (data is _i7.Obstacle) {
      return 'Obstacle';
    }
    if (data is _i8.Player) {
      return 'Player';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i10.Protocol().deserializeByClassName(data);
    }
    if (data['className'] == 'Blob') {
      return deserialize<_i2.Blob>(data['data']);
    }
    if (data['className'] == 'Board') {
      return deserialize<_i3.Board>(data['data']);
    }
    if (data['className'] == 'Body') {
      return deserialize<_i4.Body>(data['data']);
    }
    if (data['className'] == 'Food') {
      return deserialize<_i5.Food>(data['data']);
    }
    if (data['className'] == 'GameState') {
      return deserialize<_i6.GameState>(data['data']);
    }
    if (data['className'] == 'Obstacle') {
      return deserialize<_i7.Obstacle>(data['data']);
    }
    if (data['className'] == 'Player') {
      return deserialize<_i8.Player>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
