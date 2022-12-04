import 'dart:io';

import 'package:tuple/tuple.dart';

typedef Section = Tuple2<Set<int>, Set<int>>;

void main(List<String> arguments) {
  int solution1 = File('inputs/day_4.txt')
      .readAsStringSync()
      .split('\n')
      .where((line) => line.isNotEmpty)
      .map(_createSection)
      .where(_contains)
      .length;

  int solution2 = File('inputs/day_4.txt')
      .readAsStringSync()
      .split('\n')
      .where((line) => line.isNotEmpty)
      .map(_createSection)
      .where(_overlap)
      .length;

  print('1 : $solution1');
  print('2 : $solution2');
}

Section _createSection(String line) {
  List<String> section = line.split(',');
  List<int> left = section[0].split('-').map((e) => int.parse(e)).toList();
  List<int> right = section[1].split('-').map((e) => int.parse(e)).toList();
  return Tuple2(left[0].upTo(left[1]), right[0].upTo(right[1]));
}

bool _contains(Section section) {
  return section.item1.difference(section.item2).isEmpty ||
      section.item2.difference(section.item1).isEmpty;
}

bool _overlap(Section section) {
  return section.item1.intersection(section.item2).isNotEmpty;
}

extension on int {
  Set<int> upTo(int max) => {for (int i = this; i <= max; i++) i};
}
