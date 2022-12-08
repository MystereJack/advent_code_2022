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
    }
  }

  int solution1 = forest.where((e) => e.visible).length;
  int solution2 = forest.map((e) => e.score(coordinates)).reduce(max);

  print('1 : $solution1');
  print('2 : $solution2');
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

  int score(List<List<int>> coordinates) {
    int score = 1;
    score *= _scoreLeft(coordinates);
    score *= _scoreRight(coordinates);
    score *= _scoreTop(coordinates);
    score *= _scoreBottom(coordinates);

    return score;
  }

  int _scoreLeft(List<List<int>> coordinates) {
    if (positionX == 0) {
      return 0;
    }

    int score = 0;

    for (int i = positionX - 1; i >= 0; i--) {
      score += 1;
      if (coordinates[positionY][i] >= height) {
        break;
      }
    }

    return score;
  }

  int _scoreTop(List<List<int>> coordinates) {
    if (positionY == 0) {
      return 0;
    }

    int score = 0;

    for (int j = positionY - 1; j >= 0; j--) {
      score += 1;
      if (coordinates[j][positionX] >= height) {
        break;
      }
    }
    return score;
  }

  int _scoreBottom(List<List<int>> coordinates) {
    if (positionY == coordinates.length) {
      return 0;
    }

    int score = 0;

    for (int j = positionY + 1; j < coordinates.length; j++) {
      score += 1;
      if (coordinates[j][positionX] >= height) {
        break;
      }
    }

    return score;
  }

  int _scoreRight(List<List<int>> coordinates) {
    if (positionX == coordinates[positionY].length) {
      return 0;
    }

    int score = 0;

    for (int i = positionX + 1; i < coordinates[positionY].length; i++) {
      score += 1;
      if (coordinates[positionY][i] >= height) {
        break;
      }
    }

    return score;
  }

  @override
  String toString() {
    return '$height ($left, $right, $bottom, $top) - $visible';
  }
}
