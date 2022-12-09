import 'dart:io';

import 'package:quiver/core.dart';

void main(List<String> arguments) {
  final lines = File('inputs/day_9.txt')
      .readAsStringSync()
      .split('\n')
      .where((line) => line.isNotEmpty);

  List<Coordonnee> headPosition = [];
  List<Coordonnee> tailPosition = [];

  // Initial position (pour éviter les positions négatives)
  headPosition.add(Coordonnee(1000, 1000));
  tailPosition.add(Coordonnee(1000, 1000));

  for (String line in lines) {
    //print('ORDER : $line');
    final order = line.split(' ');

    for (int i = 0; i < int.parse(order[1]); i++) {
      if (order[0] == 'L') {
        headPosition.add(headPosition.last.moveLeft);
      }
      if (order[0] == 'R') {
        headPosition.add(headPosition.last.moveRight);
      }
      if (order[0] == 'U') {
        headPosition.add(headPosition.last.moveUp);
      }
      if (order[0] == 'D') {
        headPosition.add(headPosition.last.moveDown);
      }

      //print('HEAD : ${headPosition.last}');
      if (!headPosition.last.isAdjacent(tailPosition.last)) {
        tailPosition.add(tailPosition.last.moveClose(headPosition.last));
      }
      //print('TAIL : ${tailPosition.last}');
    }
  }

  print('1 : ${tailPosition.toSet().length}');
  /**
  print('2 : ${currentDirectory.root.solution2}');
   */
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
