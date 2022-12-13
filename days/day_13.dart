import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

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
    ..sort(_sort);

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
  try {
    _processData(a, b);
  } on OKException {
    return index;
  } catch (e) {
    // Nothing to do here
  }

  return 0;
}

class OKException implements Exception {}

void _processData(List<dynamic> left, List<dynamic> right) {
  for (int i = 0; i < math.max(left.length, right.length); i++) {
    if (i >= right.length) {
      throw Exception();
    } else if (i >= left.length) {
      throw OKException();
    } else {
      dynamic leftItem = left[i];
      dynamic rightItem = right[i];

      if (leftItem is int && rightItem is int) {
        if (leftItem > rightItem) {
          throw Exception();
        } else if (leftItem < rightItem) {
          throw OKException();
        }
      } else {
        _processData(
          leftItem is int ? [leftItem] : leftItem,
          rightItem is int ? [rightItem] : rightItem,
        );
      }
    }
  }
}

int _sort(dynamic left, dynamic right) {
  if (left is int && right is int) {
    return left.compareTo(right);
  }
  if (left is List && right is int) {
    return _sort(left, [right]);
  }
  if (right is List && left is int) {
    return _sort([left], right);
  }

  if (left is List && right is List) {
    int i = 0;
    while (true) {
      if (i >= left.length || i >= right.length) {
        return left.length.compareTo(right.length);
      }
      final result = _sort(left[i], right[i]);
      if (result != 0) {
        return result;
      }
      i++;
    }
  }

  throw StateError('Invalid state');
}
