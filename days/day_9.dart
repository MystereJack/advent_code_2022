import 'dart:io';

import 'package:quiver/core.dart';

void main(List<String> arguments) {
  final lines = File('inputs/day_9.txt')
      .readAsStringSync()
      .split('\n')
      .where((line) => line.isNotEmpty)
      .toList();

  final positionsSolution1 = List.generate(2, (_) => [Coordonnee(1000, 1000)]);
  _calculatePositions(positionsSolution1, lines);
  print('1 : ${positionsSolution1[1].toSet().length}');

  final positionsSolution2 = List.generate(10, (_) => [Coordonnee(1000, 1000)]);
  _calculatePositions(positionsSolution2, lines);
  print('2 : ${positionsSolution2[9].toSet().length}');
}

void _calculatePositions(List<List<Coordonnee>> positions, List<String> lines) {
  for (String line in lines) {
    final order = line.split(' ');

    for (int i = 0; i < int.parse(order[1]); i++) {
      if (order[0] == 'L') {
        positions[0].add(positions[0].last.moveLeft);
      }
      if (order[0] == 'R') {
        positions[0].add(positions[0].last.moveRight);
      }
      if (order[0] == 'U') {
        positions[0].add(positions[0].last.moveUp);
      }
      if (order[0] == 'D') {
        positions[0].add(positions[0].last.moveDown);
      }

      for (int i = 0; i < positions.length - 1; i++) {
        if (!positions[i].last.isAdjacent(positions[i + 1].last)) {
          positions[i + 1]
              .add(positions[i + 1].last.moveClose(positions[i].last));
        }
      }
    }
  }
}

class Coordonnee {
  final int x;
  final int y;

  Coordonnee(this.x, this.y);

  @override
  bool operator ==(o) => o is Coordonnee && x == o.x && y == o.y;

  @override
  int get hashCode => hash2(x.hashCode, y.hashCode);

  @override
  String toString() {
    return '[$x, $y]';
  }

  Coordonnee get moveLeft {
    return Coordonnee(x - 1, y);
  }

  Coordonnee get moveRight {
    return Coordonnee(x + 1, y);
  }

  Coordonnee get moveUp {
    return Coordonnee(x, y - 1);
  }

  Coordonnee get moveDown {
    return Coordonnee(x, y + 1);
  }

  bool isAdjacent(Coordonnee coordonnee) {
    if (x.isBetween(coordonnee.x - 1, coordonnee.x + 1) &&
        y.isBetween(coordonnee.y - 1, coordonnee.y + 1)) {
      return true;
    }

    return false;
  }

  Coordonnee moveClose(Coordonnee coordonnee) {
    if (coordonnee.x == x) {
      if (coordonnee.y < y) {
        return Coordonnee(x, y - 1);
      } else {
        return Coordonnee(x, y + 1);
      }
    } else if (coordonnee.y == y) {
      if (coordonnee.x < x) {
        return Coordonnee(x - 1, y);
      } else {
        return Coordonnee(x + 1, y);
      }
    } else {
      return Coordonnee(
        coordonnee.x > x ? x + 1 : x - 1,
        coordonnee.y > y ? y + 1 : y - 1,
      );
    }
  }
}

extension on int {
  bool isBetween(int from, int to) {
    return from <= this && this <= to;
  }
}
