import 'package:bacterialboom_server/src/util/offset.dart';

/// Calculates the approxiamte distance between two points.
double approximateDistance(Offset p1, Offset p2) {
  var xDiff = (p1.x - p2.x).abs();
  var yDiff = (p1.y - p2.y).abs();

  if (xDiff > yDiff) {
    return xDiff + (yDiff / 2);
  } else {
    return yDiff + (xDiff / 2);
  }
}
