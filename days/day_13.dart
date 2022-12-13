import 'dart:convert';
import 'dart:io';

import 'package:tuple/tuple.dart';

void main(List<String> arguments) {
  final lines = File('inputs/day_13.txt')
      .readAsStringSync()
      .split('\n')
      .where((el) => el.isNotEmpty)
      .toList();

  List<Tuple2<dynamic, dynamic>> pairs = [];
  String? firstItem;

  for (String line in lines) {
    if (firstItem != null) {
      pairs.add(Tuple2(jsonDecode(firstItem), jsonDecode(line)));
      firstItem = null;
    } else {
      firstItem = line;
    }
  }

  int solution1 = 0;
  for (int i = 0; i < pairs.length; i++) {
    print('START ${i + 1}');
    try {
      _isRightOrder(pairs[i].item1, pairs[i].item2);
    } on OKException {
      solution1 += (i + 1);
    } catch (e) {
      // Nothing to do here
    }
  }

  print('1: $solution1');
  print('2: ');
}

class OKException implements Exception {}

void _isRightOrder(List<dynamic> left, List<dynamic> right) {
  for (int i = 0; i < (right.length > left.length ? right.length : left.length); i++) {
    if (i >= right.length) {
      print('KO : RIGHT RAN OUT OF ITEMS');
      throw Exception();
    } else if (i >= left.length) {
      print('OK : LEFT RAN OUT OF ITEMS');
      throw OKException();
    } else {
      dynamic leftItem = left[i];
      dynamic rightItem = right[i];

      if (leftItem is List && rightItem is List) {
        _isRightOrder(leftItem, rightItem);
      } else if (leftItem is List && rightItem is int) {
        _isRightOrder(leftItem, [rightItem]);
      } else if (leftItem is int && rightItem is List) {
        _isRightOrder([leftItem], rightItem);
      } else {
        if (leftItem > rightItem) {
          print('KO : $leftItem > $rightItem');
          throw Exception();
        } else if (leftItem < rightItem) {
          print('OK $leftItem < $rightItem');
          throw OKException();
        }
      }
    }
  }
}
