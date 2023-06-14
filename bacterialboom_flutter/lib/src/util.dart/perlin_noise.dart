import 'dart:math';

import 'package:fast_noise/fast_noise.dart';

List<List<double>> generateLoopingPerlinNoise(int width, int height) {
  var perlin = noise2(
    512,
    512,
    noiseType: NoiseType.Perlin,
    octaves: 3,
    frequency: 0.05,
    interp: Interp.Hermite,
  );

  return noise2(
    width,
    height,
    noiseType: NoiseType.Perlin,
    octaves: 3,
    frequency: 0.05,
    interp: Interp.Hermite,
  );

  // var noiseGrid = List.generate(height, (_) => List.filled(width, 0.0));

  // for (int y = 0; y < height; y++) {
  //   for (int x = 0; x < width; x++) {
  //     double angleX = 2 * pi * x / width;
  //     double angleY = 2 * pi * y / height;

  //     double u = (1.0 + cos(angleX)) * 0.5 * 511;
  //     double v = (1.0 + sin(angleY)) * 0.5 * 511;

  //     double noiseValue = perlin[u.floor()][v.floor()];

  //     // Store the noise value in the grid
  //     noiseGrid[y][x] = noiseValue;
  //   }
  // }

  // for (var row in noiseGrid) {
  //   print(row);
  // }

  // return noiseGrid;
}
