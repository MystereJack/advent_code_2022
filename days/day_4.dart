import 'dart:io';

import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

typedef Section = Tuple2<Set<int>, Set<int>>;

void main(List<String> arguments) {
  int solution1 = File('inputs/day_4.txt')
      .readAsStringSync()
      .split('\n')
      .where((line) => line.isNotEmpty)
      .map(_createSection)
      .map(_calculateContains)
      .sum;

  int solution2 = File('inputs/day_4.txt')
      .readAsStringSync()
      .split('\n')
      .where((line) => line.isNotEmpty)
      .map(_createSection)
      .map(_calculateOverlap)
      .sum;

  print('1 : $solution1');
  print('2 : $solution2');
}

Section _createSection(String line) {
  List<String> section = line.split(',');
  List<int> left = section[0].split('-').map((e) => int.parse(e)).toList();
  List<int> right = section[1].split('-').map((e) => int.parse(e)).toList();
  return Tuple2(left[0].upTo(left[1]), right[0].upTo(right[1]));
}

int _calculateContains(Section section) {
  if (section.item1.difference(section.item2).isEmpty ||
      section.item2.difference(section.item1).isEmpty) {
    return 1;
  }
  return 0;
}

int _calculateOverlap(Section section) {
  if (section.item1.intersection(section.item2).isNotEmpty) {
    return 1;
  }
  return 0;
}

extension on int {
  Set<int> upTo(int max) => {for (int i = this; i <= max; i++) i};
}
