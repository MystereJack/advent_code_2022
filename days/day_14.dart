import 'dart:io';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'dart:math' as m;

import '../common/int_x.dart';

void main(List<String> arguments) {
  final rocks = File('inputs/day_14.txt')
      .readAsStringSync()
      .split('\n')
      .where((el) => el.isNotEmpty)
      .expand(_parseRocks)
      .toSet();

  Set<Coordinate> sands = {};
  while (true) {
    if (!_moveSandUnit(SandUnit(Coordinate(500, 0)), sands, rocks, true)) {
      break;
    }
  }

  print('1: ${sands.length}');
  _printResult(sands, rocks);

  sands = {};
  while (true) {
    if (!_moveSandUnit(SandUnit(Coordinate(500, 0)), sands, rocks, false)) {
      break;
    }
  }

  print('2: ${sands.length}');
  _printResult(sands, rocks);
}

void _printResult(Set<Coordinate> sands, Set<Coordinate> rocks) {
  int borderLeft = m.min(sands.map((e) => e.x).min, rocks.map((e) => e.x).min) - 5;
  int borderRight = m.max(sands.map((e) => e.x).max, rocks.map((e) => e.x).max) + 5;
  int borderUp = m.min(sands.map((e) => e.y).min, rocks.map((e) => e.y).min);
  int borderDown = m.max(sands.map((e) => e.y).min, rocks.map((e) => e.y).max);

  for (int i = borderUp; i <= borderDown; i++) {
    stdout.write('$i ');
    for (int j = borderLeft; j <= borderRight; j++) {
      if (sands.contains(Coordinate(j, i))) {
        stdout.write('o');
      } else if (rocks.contains(Coordinate(j, i))) {
        stdout.write('#');
      } else {
        stdout.write('.');
      }
    }
    stdout.writeln();
  }
}

bool _moveSandUnit(SandUnit sand, Set<Coordinate> sands, Set<Coordinate> rocks, bool partOne) {
  if (partOne) {
    // Si on a touché les abysses
    final abyss = rocks.map((e) => e.y).max + 1;

    if (sand.coordinate.y >= abyss) {
      return false;
    }
  } else {
    // Si on a touché le sol, on ajoute le sable
    final floor = rocks.map((e) => e.y).max + 1;

    if (sand.coordinate.y >= floor) {
      sands.add(sand.coordinate);
      return true;
    }
  }

  if (!sands.contains(sand.moveDown.coordinate) && !rocks.contains(sand.moveDown.coordinate)) {
    return _moveSandUnit(sand.moveDown, sands, rocks, partOne);
  } else if (!sands.contains(sand.moveLeft.coordinate) &&
      !rocks.contains(sand.moveLeft.coordinate)) {
    return _moveSandUnit(sand.moveLeft, sands, rocks, partOne);
  } else if (!sands.contains(sand.moveRight.coordinate) &&
      !rocks.contains(sand.moveRight.coordinate)) {
    return _moveSandUnit(sand.moveRight, sands, rocks, partOne);
  } else {
    if (!partOne) {
      if (sand.coordinate == Coordinate(500, 0)) {
        sands.add(sand.coordinate);
        return false;
      }
    }
    sands.add(sand.coordinate);
    return true;
  }
}

Iterable<Coordinate> _parseRocks(String line) sync* {
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
        yield Coordinate(c.elementAt(0), y);
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
        yield Coordinate(x, c.elementAt(1));
      }
      lastX = c.elementAt(0);
    }
  }
}

class Coordinate extends Equatable {
  final int x;
  final int y;

  Coordinate(this.x, this.y);

  @override
  List<Object?> get props => [x, y];

  @override
  String toString() {
    return '[$x,$y]';
  }
}

class SandUnit {
  final Coordinate coordinate;

  SandUnit(this.coordinate);

  SandUnit get moveDown {
    return SandUnit(Coordinate(coordinate.x, coordinate.y + 1));
  }

  SandUnit get moveLeft {
    return SandUnit(Coordinate(coordinate.x - 1, coordinate.y + 1));
  }

  SandUnit get moveRight {
    return SandUnit(Coordinate(coordinate.x + 1, coordinate.y + 1));
  }

  @override
  String toString() {
    return '[${coordinate.x},${coordinate.y}]';
  }
}
