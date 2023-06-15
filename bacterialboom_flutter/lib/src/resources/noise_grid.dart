import 'package:bacterialboom_flutter/src/util.dart/noise.dart';

const noiseGridSize = 512;

final noiseGrid = LoopingNoiseGrid(
  width: noiseGridSize,
  height: noiseGridSize,
  frequency: 1,
);
