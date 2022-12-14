import 'package:equatable/equatable.dart';

class Vector2 extends Equatable {
  final int x;
  final int y;

  Vector2(this.x, this.y);

  @override
  List<Object?> get props => [x, y];

  @override
  String toString() {
    return '[$x,$y]';
  }

  Vector2 get moveBottom {
    return Vector2(x, y + 1);
  }

  Vector2 get moveBottomLeft {
    return Vector2(x - 1, y + 1);
  }

  Vector2 get moveBottomRight {
    return Vector2(x + 1, y + 1);
  }
}
