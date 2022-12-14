import 'dart:io';
import 'package:collection/collection.dart';
import 'dart:math' as m;

import '../common/int_x.dart';
import '../common/vector2.dart';

void main(List<String> arguments) {
  final rocks = File('inputs/day_14.txt')
      .readAsStringSync()
      .split('\n')
      .where((el) => el.isNotEmpty)
      .expand(_parseRocks)
      .toSet();

  Set<Vector2> sands = {};
  while (!_moveSandUnit(Vector2(500, 0), sands, rocks, true)) {}

  print('1: ${sands.length}');
  _printResult(sands, rocks);

  sands = {};
  while (!_moveSandUnit(Vector2(500, 0), sands, rocks, false)) {}

  print('2: ${sands.length}');
  _printResult(sands, rocks);
}

void _printResult(Set<Vector2> sands, Set<Vector2> rocks) {
  int borderLeft = m.min(sands.map((e) => e.x).min, rocks.map((e) => e.x).min) - 5;
  int borderRight = m.max(sands.map((e) => e.x).max, rocks.map((e) => e.x).max) + 5;
  int borderUp = m.min(sands.map((e) => e.y).min, rocks.map((e) => e.y).min);
  int borderDown = m.max(sands.map((e) => e.y).min, rocks.map((e) => e.y).max);

  for (int i = borderUp; i <= borderDown; i++) {
    stdout.write('$i ');
    for (int j = borderLeft; j <= borderRight; j++) {
      if (sands.contains(Vector2(j, i))) {
        stdout.write('o');
      } else if (rocks.contains(Vector2(j, i))) {
        stdout.write('#');
      } else {
        stdout.write('.');
      }
    }
    stdout.writeln();
  }
}

bool _moveSandUnit(Vector2 sand, Set<Vector2> sands, Set<Vector2> rocks, bool partOne) {
  if (partOne) {
    // Si on a touché les abysses
    final abyss = rocks.map((e) => e.y).max + 1;

    if (sand.y >= abyss) {
      return false;
    }
  } else {
    // Si on a touché le sol, on ajoute le sable
    final floor = rocks.map((e) => e.y).max + 1;

    if (sand.y >= floor) {
      sands.add(sand);
      return true;
    }
  }

  if (!sands.contains(sand.moveBottom) && !rocks.contains(sand.moveBottom)) {
    return _moveSandUnit(sand.moveBottom, sands, rocks, partOne);
  } else if (!sands.contains(sand.moveBottomLeft) && !rocks.contains(sand.moveBottomLeft)) {
    return _moveSandUnit(sand.moveBottomLeft, sands, rocks, partOne);
  } else if (!sands.contains(sand.moveBottomRight) && !rocks.contains(sand.moveBottomRight)) {
    return _moveSandUnit(sand.moveBottomRight, sands, rocks, partOne);
  } else {
    if (!partOne) {
      if (sand == Vector2(500, 0)) {
        sands.add(sand);
        return false;
      }
    }
    sands.add(sand);
    return true;
  }
}

Iterable<Vector2> _parseRocks(String line) sync* {
  int lastX = 0;
  int lastY = 0;
  for (String rock in line.split(' -> ')) {
    final c = rock.split(',').map((e) => int.parse(e));
    if (lastX == 0 || lastY == 0) {
      lastX = c.elementAt(0);
      lastY = c.elementAt(1);
    }
    // Si c'est le Y qui bouge
    else if (lastX == c.elementAt(0)) {
      Set<int> listY = {};
      if (lastY < c.elementAt(1)) {
        listY = lastY.upTo(c.elementAt(1));
      } else if (lastY > c.elementAt(1)) {
        listY = c.elementAt(1).downTo(lastY);
      } else {
        throw StateError('X et Y sont égaux !');
      }
      for (int y in listY) {
        yield Vector2(c.elementAt(0), y);
      }
      lastY = c.elementAt(1);
    } // Si c'est le X qui bouge
    else if (lastY == c.elementAt(1)) {
      Set<int> listX = {};
      if (lastX < c.elementAt(0)) {
        listX = lastX.upTo(c.elementAt(0));
      } else if (lastX > c.elementAt(0)) {
        listX = c.elementAt(0).downTo(lastX);
      } else {
        throw StateError('X et Y sont égaux !');
      }
      for (int x in listX) {
        yield Vector2(x, c.elementAt(1));
      }
      lastX = c.elementAt(0);
    }
  }
}
