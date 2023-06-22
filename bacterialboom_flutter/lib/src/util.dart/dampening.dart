import 'dart:math' as math;
import 'package:flutter/material.dart';

const _baseTimeStep = 1 / 60;

double dampen({
  required double value,
  required double target,
  required double dampeningRatio,
  double dt = _baseTimeStep,
}) {
  var factor = 1 - math.exp(-dampeningRatio * dt);
  return (value * (1 - factor)) + target * factor;
}

Offset dampenOffset({
  required Offset value,
  required Offset target,
  required double dampeningRatio,
  double dt = _baseTimeStep,
}) {
  return Offset(
    dampen(
      value: value.dx,
      target: target.dx,
      dampeningRatio: dampeningRatio,
      dt: dt,
    ),
    dampen(
      value: value.dy,
      target: target.dy,
      dampeningRatio: dampeningRatio,
      dt: dt,
    ),
  );
}
