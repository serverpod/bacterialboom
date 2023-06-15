import 'dart:math';

import 'package:bacterialboom_flutter/src/util.dart/mod.dart';

const _size = 360 * 8;

final List<double> _sinTable = List.generate(
  _size,
  (i) => sin(i * 2 * pi / _size),
);

double qsin(double radians) {
  var index = mod((radians * _size / (2 * pi)).floor(), _size);
  return _sinTable[index];
}

double qcos(double radians) {
  return qsin(radians + pi / 2);
}
