import 'dart:io';

import 'package:collection/collection.dart';

void main(List<String> arguments) {
  final lines = File('inputs/day_7.txt')
      .readAsStringSync()
      .split('\n')
      .where((line) => line.isNotEmpty)
      .toList();

  Map<String, Directory> directories = {};
  String currentDirectory = '';

  for (String line in lines) {
    if (line.contains(RegExp(r'\$ cd (\w+)')) || line.contains('\$ cd /')) {
      currentDirectory = line.split(' ')[2];
      directories[currentDirectory] = Directory([], 0);
    } else if (line.contains(RegExp(r'(\d)'))) {
      directories[currentDirectory]!.size += int.parse(line.split(' ')[0]);
    } else if (line.contains(RegExp(r'dir'))) {
      directories[currentDirectory]!.subDirectories.add(line.split(' ')[1]);
    }
  }

  int solution1 =
      directories.values.map((e) => e.totalSize(directories)).where((e) => e <= 100000).sum;

  print('1 : $solution1');
  //print('2 : $solution2');
}

class Directory {
  List<String> subDirectories;
  int size;

  Directory(this.subDirectories, this.size);

  int totalSize(Map<String, Directory> full) {
    int r = size;
    for (String subDirectory in subDirectories) {
      r += full[subDirectory]!.totalSize(full);
    }
    return r;
  }

  @override
  String toString() {
    return '$subDirectories ($size)';
  }
}
