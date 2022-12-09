import 'dart:io';
import 'dart:math';

import 'package:tuple/tuple.dart';

class Tree {
  int height;
  Tree? left;
  Tree? right;
  Tree? top;
  Tree? bottom;

  Tree(
    this.height, {
    this.left,
    this.right,
    this.top,
    this.bottom,
  });

  int _scoreLeft(int h) {
    int score = 0;

    if (left != null) {
      score += 1;
      if (h > left!.height) {
        score += left!._scoreLeft(h);
      }
    }

    return score;
  }

  int _scoreRight(int h) {
    int score = 0;

    if (right != null) {
      score += 1;
      if (h > right!.height) {
        score += right!._scoreRight(h);
      }
    }

    return score;
  }

  int _scoreBottom(int h) {
    int score = 0;

    if (bottom != null) {
      score += 1;
      if (h > bottom!.height) {
        score += bottom!._scoreBottom(h);
      }
    }

    return score;
  }

  int _scoreTop(int h) {
    int score = 0;

    if (top != null) {
      score += 1;
      if (h > top!.height) {
        score += top!._scoreTop(h);
      }
    }

    return score;
  }

  bool _leftVisible(int h) {
    if (left != null && h <= left!.height) {
      return false;
    }

    if (left == null) {
      return true;
    }

    return left!._leftVisible(h);
  }

  bool _rightVisible(int h) {
    if (right != null && h <= right!.height) {
      return false;
    }

    if (right == null) {
      return true;
    }

    return right!._rightVisible(h);
  }

  bool _topVisible(int h) {
    if (top != null && h <= top!.height) {
      return false;
    }

    if (top == null) {
      return true;
    }

    return top!._topVisible(h);
  }

  bool _bottomVisible(int h) {
    if (bottom != null && h <= bottom!.height) {
      return false;
    }

    if (bottom == null) {
      return true;
    }

    return bottom!._bottomVisible(h);
  }

  bool get visible {
    return _leftVisible(height) ||
        _rightVisible(height) ||
        _topVisible(height) ||
        _bottomVisible(height);
  }

  int get score {
    return _scoreLeft(height) *
        _scoreRight(height) *
        _scoreBottom(height) *
        _scoreTop(height);
  }
}

void main(List<String> arguments) {
  final lines = File('inputs/day_8.txt')
      .readAsStringSync()
      .split('\n')
      .where((line) => line.isNotEmpty)
      .toList();

  Map<Tuple2<int, int>, Tree> mapForest = {};

  for (int i = 0; i < lines.length; i++) {
    final chars = lines[i].split('');
    for (int j = 0; j < chars.length; j++) {
      mapForest[Tuple2(j, i)] = Tree(int.parse(chars[j]));
    }
  }

  _populateNeighbors(mapForest, lines);

  int solution1 = mapForest.values.where((e) => e.visible).length;
  int solution2 = mapForest.values.map((e) => e.score).reduce(max);

  print('1 : $solution1');
  print('2 : $solution2');
}

void _populateNeighbors(Map<Tuple2<int, int>, Tree> map, List<String> lines) {
  for (var entry in map.entries) {
    if (entry.key.item1 != 0) {
      entry.value.left = map[Tuple2(entry.key.item1 - 1, entry.key.item2)];
    }

    if (entry.key.item1 + 1 != lines.length) {
      entry.value.right = map[Tuple2(entry.key.item1 + 1, entry.key.item2)];
    }

    if (entry.key.item2 != 0) {
      entry.value.top = map[Tuple2(entry.key.item1, entry.key.item2 - 1)];
    }

    if (entry.key.item2 + 1 != lines[0].length) {
      entry.value.bottom = map[Tuple2(entry.key.item1, entry.key.item2 + 1)];
    }
  }
}
