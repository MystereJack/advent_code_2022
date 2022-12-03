// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) {
  // PART ONE
  int partOne = 0;
  File('day_3/input.txt')
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .forEach((element) {
    List<String> full = element.split('');
    Set<String> sub1 = full.sublist(0, (full.length / 2).floor()).toSet();
    Set<String> sub2 =
        full.sublist((full.length / 2).floor(), full.length).toSet();

    partOne += sub1.intersection(sub2).first.score;
  }).then((_) {
    print('SCORE PART 1 : $partOne');
  });

  // PART TWO
  int partTwo = 0;
  List<Set<String>> group = [];
  File('day_3/input.txt')
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .forEach((element) {
    List<String> list = element.split('');
    group.add(list.toSet());

    if (group.length == 3) {
      partTwo +=
          group[0].intersection(group[1].intersection(group[2])).first.score;
      group = [];
    }
  }).then((value) {
    print('SCORE PART 2 : $partTwo');
  });
}

extension on String {
  bool get isUppercase {
    return this == toUpperCase();
  }

  int get score {
    const List<String> alphabet = [
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z'
    ];

    return isUppercase
        ? ((alphabet.indexOf(toLowerCase()) + 1) + 26)
        : (alphabet.indexOf(this) + 1);
  }
}
