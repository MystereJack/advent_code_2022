import 'dart:math';

import 'int_x.dart';
import 'vector2.dart';

class Grid2<T> {
  Grid2({
    required this.defaultValue,
  })  : _cells = <Vector2, T>{},
        _min = Vector2.zero,
        _max = Vector2.zero;

  final T defaultValue;

  final Map<Vector2, T> _cells;

  Vector2 get minLocation => _min;
  Vector2 _min;

  Vector2 get maxLocation => _max;
  Vector2 _max;

  bool isSet(Vector2 p) => _cells.containsKey(p);

  bool isSetValue(Vector2 p, T value) => _cells.containsKey(p) && _cells[p] == value;

  T cell(Vector2 p) => _cells[p] ?? defaultValue;

  void setCell(Vector2 p, T value) {
    if (!isSet(p)) {
      _min = Vector2(min(_min.x, p.x), min(_min.y, p.y));
      _max = Vector2(max(_max.x, p.x), max(_max.y, p.y));
    }
    _cells[p] = value;
  }

  int numSetCells() => _cells.length;

  int numSetCellsWhere(bool Function(T) test) => _cells.values.where(test).length;

  List<Vector2> findCells(bool Function(MapEntry<Vector2, T>) test) =>
      _cells.entries.where(test).map((e) => e.key).toList();

  String printLine(int line) {
    return [line]
        .map((int y) => _min.x.upTo(_max.x).map((int x) {
              final Vector2 p = Vector2(x, y);
              return isSet(p) ? cell(p).toString() : defaultValue;
            }).join(' '))
        .join('\n');
  }

  @override
  String toString() {
    return _min.y
        .upTo(_max.y)
        .map((int y) => _min.x.upTo(_max.x).map((int x) {
              final Vector2 p = Vector2(x, y);
              return isSet(p) ? cell(p).toString() : defaultValue;
            }).join(' '))
        .join('\n');
  }
}
