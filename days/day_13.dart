import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';

void main(List<String> arguments) {
  solution1();
  solution2();
}

void solution2() {
  final sep1 = jsonDecode('[[2]]');
  final sep2 = jsonDecode('[[6]]');

  final lines = File('inputs/day_13.txt')
      .readAsStringSync()
      .split('\n')
      .where((el) => el.isNotEmpty)
      .map((e) => jsonDecode(e))
      .toList()
    ..add(sep1)
    ..add(sep2)
    ..sort(_compare);

  int solution2 = (lines.indexOf(sep1) + 1) * (lines.indexOf(sep2) + 1);

  print('2: $solution2');
}

void solution1() {
  int solution1 = File('inputs/day_13.txt')
      .readAsStringSync()
      .split('\n')
      .where((el) => el.isNotEmpty)
      .slices(2)
      .map((pair) => pair.map((e) => jsonDecode(e)))
      .mapIndexed((i, pair) => _solution1(i, pair.first, pair.last))
      .sum;

  print('1: $solution1');
}

int _solution1(int index, dynamic a, dynamic b) {
  return _compare(a, b) == -1 ? index : 0;
}

int _compare(dynamic left, dynamic right) {
  if (left is int && right is int) {
    return left.compareTo(right);
  }
  if (left is List && right is int) {
    return _compare(left, [right]);
  }
  if (right is List && left is int) {
    return _compare([left], right);
  }

  if (left is List && right is List) {
    int i = 0;
    while (true) {
      if (i >= left.length || i >= right.length) {
        return left.length.compareTo(right.length);
      }
      final result = _compare(left[i], right[i]);
      if (result != 0) {
        return result;
      }
      i++;
    }
  }

  throw Exception();
}
