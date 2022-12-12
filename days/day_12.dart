import 'dart:io';
import 'dart:math';

import 'package:dijkstra/dijkstra.dart';
import 'package:tuple/tuple.dart';

void main(List<String> arguments) {
  final lines = File('inputs/day_12.txt')
      .readAsStringSync()
      .split('\n')
      .where((line) => line.isNotEmpty)
      .toList();

  Map<Tuple2<int, int>, Mountain> mountains = {};

  for (int i = 0; i < lines.length; i++) {
    final chars = lines[i].split('');
    for (int j = 0; j < chars.length; j++) {
      final score = chars[j].score;

      if (score == 0 || score == 27) {
        mountains[Tuple2(j, i)] = Mountain(score.toString(), score);
      } else if (score == 1) {
        mountains[Tuple2(j, i)] = Mountain('_A$j$i', score);
      } else {
        mountains[Tuple2(j, i)] = Mountain('$j-$i', score);
      }
    }
  }

  _populateNeighbors(mountains, lines);

  Map graph = {};

  for (Mountain mountain in mountains.values) {
    graph[mountain.id] = {};

    if (mountain.left != null) {
      graph[mountain.id][mountain.left] = 1;
    }
    if (mountain.right != null) {
      graph[mountain.id][mountain.right] = 1;
    }
    if (mountain.up != null) {
      graph[mountain.id][mountain.up] = 1;
    }
    if (mountain.down != null) {
      graph[mountain.id][mountain.down] = 1;
    }
  }

  print('1: ${Dijkstra.findPathFromGraph(graph, '0', '27').length - 1}');

  int solution2 = mountains.values
      .where((e) => e.id.startsWith('_A'))
      .map((mountain) => Dijkstra.findPathFromGraph(graph, mountain.id, '27').length)
      .where((element) => element != 0)
      .reduce(min);
  print('2 : ${solution2 - 1}');
}

extension on String {
  int get score {
    return this == toUpperCase()
        ? this == 'S'
            ? 0
            : 27
        : codeUnitAt(0) - 96;
  }
}

void _populateNeighbors(Map<Tuple2<int, int>, Mountain> map, List<String> lines) {
  for (var entry in map.entries) {
    if (entry.key.item1 != 0) {
      entry.value.left = entry.value.goTo(map[Tuple2(entry.key.item1 - 1, entry.key.item2)]!);
    }

    if (entry.key.item1 + 1 != lines[0].length) {
      entry.value.right = entry.value.goTo(map[Tuple2(entry.key.item1 + 1, entry.key.item2)]!);
    }

    if (entry.key.item2 != 0) {
      entry.value.up = entry.value.goTo(map[Tuple2(entry.key.item1, entry.key.item2 - 1)]!);
    }

    if (entry.key.item2 + 1 != lines.length) {
      entry.value.down = entry.value.goTo(map[Tuple2(entry.key.item1, entry.key.item2 + 1)]!);
    }
  }
}

class Mountain {
  String id;
  int height;
  String? left;
  String? right;
  String? up;
  String? down;

  Mountain(
    this.id,
    this.height, {
    this.left,
    this.right,
    this.up,
    this.down,
  });

  String? goTo(Mountain other) {
    return height + 1 >= other.height ? other.id : null;
  }
}
