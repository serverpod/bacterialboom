import 'dart:math' as math;
import 'package:flutter/material.dart';

const _baseTimeStep = 1 / 60;

double dampen({
  required double value,
  required double target,
  required double dampening,
  double dt = _baseTimeStep,
}) {
  var timeAdjustedDampening = math.pow(dampening, dt / _baseTimeStep);
  return (value * (1 - timeAdjustedDampening)) + target * timeAdjustedDampening;
}

Offset dampenOffset({
  required Offset value,
  required Offset target,
  required double dampening,
  double dt = _baseTimeStep,
}) {
  return Offset(
    dampen(
      value: value.dx,
      target: target.dx,
      dampening: dampening,
      dt: dt,
    ),
    dampen(
      value: value.dy,
      target: target.dy,
      dampening: dampening,
      dt: dt,
    ),
  );
}
