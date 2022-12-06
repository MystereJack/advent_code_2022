import 'dart:io';

void main(List<String> arguments) {
  final chars = File('inputs/day_6.txt')
      .readAsStringSync()
      .split('')
      .where((line) => line.isNotEmpty)
      .toList();

  int solution1 = _findSolution(chars, 4);
  int solution2 = _findSolution(chars, 14);

  print('1 : $solution1');
  print('2 : $solution2');
}

int _findSolution(List<String> chars, int markerLength) {
  for (int i = 0; i < chars.length; i++) {
    final sublist =
        chars.sublist(i, i + markerLength <= chars.length ? i + markerLength : chars.length);

    if (!sublist.hasDoublons) {
      return chars.sublist(0, i + markerLength).reduce((v, e) => v += e).length;
    }
  }
  return 0;
}

extension ListX<E> on List<E> {
  bool get hasDoublons {
    return length != toSet().length;
  }
}
