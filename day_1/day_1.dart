import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main(List<String> arguments) {
  List<int> elves = [];
  var calories = 0;
  File('day_1/input.txt')
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .forEach((value) {
    if (value.isEmpty) {
      elves.add(calories);
      calories = 0;
    } else {
      calories += int.parse(value);
    }
  }).then((_) {
    elves.sort((a, b) => b.compareTo(a));
    print('FIRST : ${elves.reduce(max)}');
    print('SECOND : ${elves.sublist(0, 3).fold(0, (p, e) => p + e)}');
  });
}
