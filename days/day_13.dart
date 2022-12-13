import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:quiver/iterables.dart';
import 'package:tuple/tuple.dart';

void main(List<String> arguments) {
  int solution1 = partition(
          File('inputs/day_13.txt')
              .readAsStringSync()
              .split('\n')
              .where((el) => el.isNotEmpty)
              .toList(),
          2)
      .map(_createTuple)
      .fold(Tuple2(1, 0), _solution1)
      .item2;

  print('1: $solution1');
}

Tuple2<dynamic, dynamic> _createTuple(List<String> lines) {
  return Tuple2(jsonDecode(lines[0]), jsonDecode(lines[1]));
}

Tuple2<int, int> _solution1(Tuple2<int, int> previous, Tuple2<dynamic, dynamic> data) {
  int total = previous.item2;
  try {
    _processData(data.item1, data.item2);
  } on OKException {
    total += previous.item1;
  } catch (e) {
    // Nothing to do here
  }

  return Tuple2(previous.item1 + 1, total);
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
