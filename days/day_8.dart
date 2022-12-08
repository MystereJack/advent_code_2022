import 'dart:io';
import 'dart:math';

void main(List<String> arguments) {
  final lines = File('inputs/day_8.txt')
      .readAsStringSync()
      .split('\n')
      .where((line) => line.isNotEmpty);

  List<List<int>> coordinates = [];

  for (String line in lines) {
    List<int> row = [];
    for (String tree in line.split('')) {
      try {
        row.add(int.parse(tree));
      } catch (e) {
        // Nothing to do here ...
      }
    }
    coordinates.add(row);
  }

  List<Tree> forest = [];

  for (int i = 0; i < coordinates.length; i++) {
    for (int j = 0; j < coordinates[i].length; j++) {
      forest.add(Tree(
        j,
        i,
        coordinates[i][j],
        left: _calculateLeft(coordinates[i], j),
        right: _calculateRight(coordinates[i], j),
        bottom: _calculateBottom(coordinates, i, j),
        top: _calculateTop(coordinates, i, j),
      ));
      print(forest.last);
    }
  }

  int solution1 = forest.where((e) => e.visible).length;

  print('1 : $solution1');
  // print('2 : ${currentDirectory.root.solution2}');
}

int? _calculateTop(List<List<int>> coordinates, int i, int j) {
  if (i == 0) {
    return null;
  }

  return coordinates.sublist(0, i).reduce((v, e) => v[j] > e[j] ? v : e)[j];
}

int? _calculateBottom(List<List<int>> coordinates, int i, int j) {
  if (i == coordinates.length - 1) {
    return null;
  }

  return coordinates
      .sublist(i + 1, coordinates.length)
      .reduce((v, e) => v[j] > e[j] ? v : e)[j];
}

int? _calculateLeft(List<int> row, int j) {
  if (j == 0) {
    return null;
  }

  return row.sublist(0, j).reduce(max);
}

int? _calculateRight(List<int> row, int j) {
  if (j == row.length - 1) {
    return null;
  }

  return row.sublist(j + 1, row.length).reduce(max);
}

class Tree {
  int positionX;
  int positionY;
  int height;

  // Highest position
  int? left;
  int? right;
  int? top;
  int? bottom;

  Tree(this.positionX, this.positionY, this.height,
      {this.left, this.right, this.top, this.bottom});

  bool get visible {
    if (left == null || right == null || top == null || bottom == null) {
      return true;
    }

    if (left! < height ||
        right! < height ||
        top! < height ||
        bottom! < height) {
      return true;
    }

    return false;
  }

  @override
  String toString() {
    return '$height ($left, $right, $bottom, $top) - $visible';
  }
}
