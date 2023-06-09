class Offset {
  final double x;
  final double y;

  Offset(this.x, this.y);

  Offset operator +(Offset other) => Offset(x + other.x, y + other.y);

  Offset operator -(Offset other) => Offset(x - other.x, y - other.y);

  Offset operator *(double factor) => Offset(x * factor, y * factor);

  Offset operator /(double factor) => Offset(x / factor, y / factor);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Offset &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => 'Offset{x: $x, y: $y}';

  const Offset.zero()
      : x = 0.0,
        y = 0.0;
}
