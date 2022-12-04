import 'dart:io';

import 'package:collection/collection.dart';

void main(List<String> arguments) {
  final lines = File('inputs/day_1.txt').readAsStringSync().split('\n');

  List<int> elves = [];
  var calories = 0;

  for (var line in lines) {
    if (line.isEmpty) {
      elves.add(calories);
      calories = 0;
    } else {
      calories += int.parse(line);
    }
  }

  elves.sort((a, b) => b.compareTo(a));
  print('FIRST : ${elves.max}');
  print('SECOND : ${elves.sublist(0, 3).sum}');
}
