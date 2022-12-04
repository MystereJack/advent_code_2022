import 'dart:io';

import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

typedef Section = Tuple2<String, String>;
typedef Assignment = Tuple2<int, int>;

void main(List<String> arguments) {
  int solution1 = File('inputs/day_4.txt')
      .readAsStringSync()
      .split('\n')
      .where((line) => line.isNotEmpty)
      .map(_createSection)
      .map(_createAssignment)
      .map(_calculateContains)
      .sum;

  int solution2 = File('inputs/day_4.txt')
      .readAsStringSync()
      .split('\n')
      .where((line) => line.isNotEmpty)
      .map(_createSection)
      .map(_createAssignment)
      .map(_calculateOverlap)
      .sum;

  print('1 : $solution1');
  print('2 : $solution2');
}

Section _createSection(String line) {
  List<String> split = line.split(',');
  return Tuple2(split[0], split[1]);
}

Iterable<Assignment> _createAssignment(Section section) sync* {
  List<String> split = section.item1.split('-');
  yield Tuple2(int.parse(split[0]), int.parse(split[1]));
  split = section.item2.split('-');
  yield Tuple2(int.parse(split[0]), int.parse(split[1]));
}

int _calculateContains(Iterable<Assignment> assignments) {
  if (assignments.elementAt(0).contains(assignments.elementAt(1))) {
    return 1;
  } else if (assignments.elementAt(1).contains(assignments.elementAt(0))) {
    return 1;
  } else {
    return 0;
  }
}

int _calculateOverlap(Iterable<Assignment> assignments) {
  if (assignments.elementAt(0).overlap(assignments.elementAt(1))) {
    return 1;
  } else if (assignments.elementAt(1).overlap(assignments.elementAt(0))) {
    return 1;
  } else {
    return 0;
  }
}

extension on Assignment {
  bool contains(Assignment assignment) {
    if (item1 <= assignment.item1 && item2 >= assignment.item2) {
      return true;
    }

    return false;
  }

  bool overlap(Assignment assignment) {
    if (item1.isBetween(assignment.item1, assignment.item2) ||
        item2.isBetween(assignment.item1, assignment.item2)) {
      return true;
    }

    return false;
  }
}

extension on int {
  bool isBetween(int first, int last) {
    return this >= first && this <= last;
  }
}
