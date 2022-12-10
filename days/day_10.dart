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
  // print('2 : ${positionsSolution2[9].toSet().length}');
}

Map<int, int> _executeOrder(Map<int, int> referentiel, String line) {
  final split = line.split(' ');
  final e = referentiel.entries.last;
  if (split[0].contains('noop')) {
    referentiel[e.key + 1] = e.value;
  } else if (split[0].contains('addx')) {
    referentiel[e.key + 1] = e.value;
    referentiel[e.key + 2] = e.value + int.parse(split[1]);
  }

  return referentiel;
}

extension on int {
  Set<int> upTo(
    int max,
    int range,
  ) =>
      {for (int i = this; i <= max; i += range) i};
}
