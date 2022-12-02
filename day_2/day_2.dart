// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) {
  int scoreTotalPartOne = 0;
  int scoreTotalPartTwo = 0;
  File('day_2/input.txt')
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .forEach((element) {
    // PART 1
    var shapeOpponent = _getShape(element.substring(0, 1));
    var shapeMine = _getShape(element.substring(2, 3));

    scoreTotalPartOne += shapeMine.score(shapeOpponent);

    // PART 2
    var result = _getResult(element.substring(2, 3));
    scoreTotalPartTwo += result.score(shapeOpponent);
  }).then((value) {
    print('SCORE PART 1 : $scoreTotalPartOne');
    print('SCORE PART 2 : $scoreTotalPartTwo');
  });
}

Result _getResult(String result) {
  switch (result) {
    case 'X':
      {
        return Result.LOSE;
      }
    case 'Y':
      {
        return Result.DRAW;
      }
    case 'Z':
      {
        return Result.WIN;
      }

    default:
      throw Exception();
  }
}

Shape _getShape(String shape) {
  switch (shape) {
    case 'A':
    case 'X':
      {
        return Shape.ROCK;
      }

    case 'B':
    case 'Y':
      {
        return Shape.PAPER;
      }

    case 'C':
    case 'Z':
      {
        return Shape.SCISSORS;
      }

    default:
      throw Exception();
  }
}

enum Result {
  LOSE,
  WIN,
  DRAW;
}

enum Shape {
  ROCK,
  PAPER,
  SCISSORS;
}

extension on Shape {
  Shape get beat {
    if (this == Shape.ROCK) return Shape.SCISSORS;
    if (this == Shape.PAPER) return Shape.ROCK;
    if (this == Shape.SCISSORS) return Shape.PAPER;
    throw Exception();
  }

  Shape get beatenBy {
    if (this == Shape.ROCK) return Shape.PAPER;
    if (this == Shape.PAPER) return Shape.SCISSORS;
    if (this == Shape.SCISSORS) return Shape.ROCK;
    throw Exception();
  }

  int get shapeScore {
    switch (this) {
      case Shape.ROCK:
        {
          return 1;
        }
      case Shape.PAPER:
        {
          return 2;
        }
      case Shape.SCISSORS:
        {
          return 3;
        }
    }
  }

  int score(Shape other) {
    if (other == this) {
      return Result.DRAW.resultScore + shapeScore;
    }

    return other.beatenBy == this
        ? Result.WIN.resultScore + shapeScore
        : Result.LOSE.resultScore + shapeScore;
  }
}

extension on Result {
  int get resultScore {
    switch (this) {
      case Result.WIN:
        {
          return 6;
        }
      case Result.LOSE:
        {
          return 0;
        }
      case Result.DRAW:
        {
          return 3;
        }
    }
  }

  int score(Shape other) {
    switch (this) {
      case Result.WIN:
        {
          return other.beatenBy.shapeScore + resultScore;
        }
      case Result.LOSE:
        {
          return other.beat.shapeScore + resultScore;
        }
      case Result.DRAW:
        {
          return other.shapeScore + resultScore;
        }
    }
  }
}
