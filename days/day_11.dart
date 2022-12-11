import 'dart:collection';

final int mod = 9699690;

void main(List<String> arguments) {
  _solution1();
  _solution2();
}

void _solution1() {
  Map<int, Monkey> monkeys = _createMonkeyMap();

  for (int i = 1; i <= 20; i++) {
    _processRound(monkeys, true);
  }

  List<Monkey> m = monkeys.values.toList()
    ..sort((a, b) => b.inspectedItems.compareTo(a.inspectedItems));

  int solution1 =
      m.take(2).map((e) => e.inspectedItems).reduce((a, b) => a * b);

  print('1 : $solution1');
}

void _solution2() {
  Map<int, Monkey> monkeys = _createMonkeyMap();

  for (int i = 1; i <= 10000; i++) {
    _processRound(monkeys, false);
  }

  List<Monkey> m = monkeys.values.toList()
    ..sort((a, b) => b.inspectedItems.compareTo(a.inspectedItems));

  int solution2 =
      m.take(2).map((e) => e.inspectedItems).reduce((a, b) => a * b);

  print('2 : $solution2');
}

Map<int, Monkey> _createMonkeyMap() {
  return {
    0: Monkey(
      Queue.of([89, 74]),
      (o) => o * 5,
      (v) => v % 17 == 0 ? 4 : 7,
    ),
    1: Monkey(
      Queue.of([75, 69, 87, 57, 84, 90, 66, 50]),
      (old) => old + 3,
      (v) => v % 7 == 0 ? 3 : 2,
    ),
    2: Monkey(
      Queue.of([55]),
      (old) => old + 7,
      (v) => v % 13 == 0 ? 0 : 7,
    ),
    3: Monkey(
      Queue.of([69, 82, 69, 56, 68]),
      (old) => old + 5,
      (v) => v % 2 == 0 ? 0 : 2,
    ),
    4: Monkey(
      Queue.of([72, 97, 50]),
      (old) => old + 2,
      (v) => v % 19 == 0 ? 6 : 5,
    ),
    5: Monkey(
      Queue.of([90, 84, 56, 92, 91, 91]),
      (old) => old * 19,
      (v) => v % 3 == 0 ? 6 : 1,
    ),
    6: Monkey(
      Queue.of([63, 93, 55, 53]),
      (old) => old * old,
      (v) => v % 5 == 0 ? 3 : 1,
    ),
    7: Monkey(
      Queue.of([50, 61, 52, 58, 86, 68, 97]),
      (old) => old + 4,
      (v) => v % 11 == 0 ? 5 : 4,
    ),
  };
}

void _processRound(Map<int, Monkey> monkeys, bool withDivision) {
  for (Monkey monkey in monkeys.values) {
    while (monkey.items.isNotEmpty) {
      int worryLevel = monkey.operation(monkey.items.removeFirst());

      if (withDivision) {
        worryLevel = worryLevel ~/ 3;
      } else {
        worryLevel = worryLevel % mod;
      }

      int nextMonkey = monkey.throwTo(worryLevel);
      monkeys[nextMonkey]!.items.addLast(worryLevel);
      monkey.inspectedItems++;
    }
  }
}

class Monkey {
  final Queue<int> items;
  final int Function(int) operation;
  final int Function(int) throwTo;
  int inspectedItems = 0;

  Monkey(
    this.items,
    this.operation,
    this.throwTo,
  );
}
