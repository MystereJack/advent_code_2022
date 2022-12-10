import 'dart:io';

void main(List<String> arguments) {
  Map<int, int> journal = File('inputs/day_10.txt')
      .readAsStringSync()
      .split('\n')
      .where((line) => line.isNotEmpty)
      .fold(<int, int>{1: 1}, _executeOrder);

  Set<int> relevantCycles = 20.upTo(journal.keys.length, 40);

  final solution1 = journal.entries.fold(0, (p, e) {
    if (relevantCycles.contains(e.key)) {
      return p + (e.value * e.key);
    }
    return p;
  });

  print('1 : $solution1');

  int nbLine = 0;
  for (var element in journal.entries) {
    if ((element.key - 1 - (nbLine * 40))
        .isBetween(element.value - 1, element.value + 1)) {
      stdout.write('#');
    } else {
      stdout.write('.');
    }

    if (element.key % 40 == 0) {
      stdout.writeln('');
      nbLine++;
    }
  }
}

Map<int, int> _executeOrder(Map<int, int> ref, String line) {
  final split = line.split(' ');
  final e = ref.entries.last;
  if (split[0].contains('noop')) {
    ref[e.key + 1] = e.value;
  } else if (split[0].contains('addx')) {
    ref[e.key + 1] = e.value;
    ref[e.key + 2] = e.value + int.parse(split[1]);
  }

  return ref;
}

extension on int {
  Set<int> upTo(
    int max,
    int range,
  ) =>
      {for (int i = this; i <= max; i += range) i};

  bool isBetween(int from, int to) {
    return from <= this && this <= to;
  }
}
