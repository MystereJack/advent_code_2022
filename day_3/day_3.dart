// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:quiver/iterables.dart';

void main(List<String> arguments) {
  final lines = File('inputs/day_3.txt')
      .readAsStringSync()
      .split('\n')
      .where((line) => line.isNotEmpty);

  // PART ONE
  final partOne = lines.map((e) {
    final full = e.split('');
    final s1 = full.sublist(0, (full.length ~/ 2)).toSet();
    final s2 = full.sublist((full.length ~/ 2)).toSet();

    return s1.intersection(s2).first.score;
  }).sum;

  // PART TWO

  final partTwo = partition(lines, 3).map(_split).map(_groupScore).sum;

  print('PART 1 : $partOne');
  print('PART 2 : $partTwo');
}

Iterable<Set<String>> _split(List<String> value) {
  return value.map((e) => e.split('').toSet());
}

int _groupScore(Iterable<Set<String>> value) {
  return value
      .elementAt(0)
      .intersection(
        value.elementAt(1).intersection(
              value.elementAt(2),
            ),
      )
      .first
      .score;
}

extension on String {
  int get score {
    return this == toUpperCase() ? codeUnitAt(0) - 38 : codeUnitAt(0) - 96;
  }
}
