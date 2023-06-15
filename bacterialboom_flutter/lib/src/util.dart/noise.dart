import 'dart:math';

import 'package:open_simplex_2/open_simplex_2.dart';

class LoopingNoiseGrid {
  LoopingNoiseGrid({
    required this.width,
    required this.height,
    this.frequency = 0.1,
    this.fast = false,
    this.seed = 42,
  }) {
    _noise = fast ? OpenSimplex2F(seed) : OpenSimplex2S(seed);
    _grid = List.filled(width * height, 0.0);

    for (int y = 0; y < height; y += 1) {
      for (int x = 0; x < width; x += 1) {
        var u = x / width * 2 * pi;
        var v = y / height * 2 * pi;
        var nx = cos(u);
        var ny = sin(u);
        var nz = cos(v);
        var nw = sin(v);

        _grid[y * width + x] = _noise.noise4Classic(
          frequency * nx,
          frequency * ny,
          frequency * nz,
          frequency * nw,
        );
      }
    }
  }

  final int width;
  final int height;
  final double frequency;
  final bool fast;
  final int seed;

  late final OpenSimplex2 _noise;
  late final List<double> _grid;

  double get(int x, int y) {
    x = ((x % width) + width) % width;
    y = ((y % height) + height) % height;
    return _grid[y * width + x];
  }

  List<double> getCircle({
    required double xCenter,
    required double yCenter,
    required double radius,
    int numPoints = 360,
  }) {
    var circlePoints = List<double>.filled(numPoints, 0.0);

    for (var i = 0; i < numPoints; i++) {
      var rad = 2 * pi * i / numPoints;
      var x = (xCenter + radius * cos(rad)).floor();
      var y = (yCenter + radius * sin(rad)).floor();

      var xMod = ((x % width) + width) % width;
      var yMod = ((y % height) + height) % height;

      circlePoints[i] = _grid[yMod * width + xMod];
    }

    return circlePoints;
  }
}
