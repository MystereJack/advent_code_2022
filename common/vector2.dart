import 'package:equatable/equatable.dart';

class Vector2 extends Equatable {
  final int x;
  final int y;

  const Vector2(this.x, this.y);

  static const Vector2 zero = Vector2(0, 0);

  @override
  List<Object?> get props => [x, y];

  @override
  String toString() {
    return '[$x,$y]';
  }

  Vector2 get moveUp => Vector2(x, y - 1);
  Vector2 get moveUpLeft => Vector2(x - 1, y - 1);
  Vector2 get moveUpRight => Vector2(x + 1, y - 1);
  Vector2 get moveLeft => Vector2(x - 1, y);
  Vector2 get moveRight => Vector2(x + 1, y);
  Vector2 get moveBottom => Vector2(x, y + 1);
  Vector2 get moveBottomLeft => Vector2(x - 1, y + 1);
  Vector2 get moveBottomRight => Vector2(x + 1, y + 1);
}
