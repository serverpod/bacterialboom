import 'dart:ui';

extension OffsetExtension on Offset {
  Offset get normalized {
    var distance = this.distance;
    if (distance == 0.0) return Offset.zero;
    return Offset(dx / distance, dy / distance);
  }

  Offset get cappedNormalized {
    var distance = this.distance;
    if (distance == 0.0) return Offset.zero;
    if (distance < 1.0) return this;
    return normalized;
  }
}
