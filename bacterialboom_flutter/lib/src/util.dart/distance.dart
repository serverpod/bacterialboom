import 'dart:ui';

/// Calculates the approxiamte distance between two points.
double approximateDistance(Offset p1, Offset p2) {
  var xDiff = (p1.dx - p2.dx).abs();
  var yDiff = (p1.dy - p2.dy).abs();

  if (xDiff > yDiff) {
    return xDiff + (yDiff / 2);
  } else {
    return yDiff + (xDiff / 2);
  }
}
