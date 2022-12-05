import 'dart:io';

import 'package:tuple/tuple.dart';

import '../common/stack.dart';

void main(List<String> arguments) {
  String solution1 = _obtainResult(
    File('inputs/day_5.txt')
        .readAsStringSync()
        .split('\n')
        .sublist(10)
        .where((line) => line.isNotEmpty)
        .map(_createOrder)
        .fold(_initial, _applyOrder9000),
  );

  String solution2 = _obtainResult(
    File('inputs/day_5.txt')
        .readAsStringSync()
        .split('\n')
        .sublist(10)
        .where((line) => line.isNotEmpty)
        .map(_createOrder)
        .fold(_initial, _applyOrder9001),
  );

  print('1 : $solution1');
  print('2 : $solution2');
}

List<Stack<String>> get _initial {
  return [
    Stack(List.from(['D', 'T', 'R', 'B', 'J', 'L', 'W', 'G'])),
    Stack(List.from(['S', 'W', 'C'])),
    Stack(List.from(['R', 'Z', 'T', 'M'])),
    Stack(List.from(['D', 'T', 'C', 'H', 'S', 'P', 'V'])),
    Stack(List.from(['G', 'P', 'T', 'L', 'D', 'Z'])),
    Stack(List.from(['F', 'B', 'R', 'Z', 'J', 'Q', 'C', 'D'])),
    Stack(List.from(['S', 'B', 'D', 'J', 'M', 'F', 'T', 'R'])),
    Stack(List.from(['L', 'H', 'R', 'B', 'T', 'V', 'M'])),
    Stack(List.from(['Q', 'P', 'D', 'S', 'V'])),
  ];
}

List<Stack<String>> _applyOrder9000(List<Stack<String>> p, Order o) {
  var departure = p[o.item2];
  var arrival = p[o.item3];

  for (int i = 1; i <= o.item1; i++) {
    arrival.push(departure.pop());
  }

  p[o.item2] = departure;
  p[o.item3] = arrival;

  return p;
}

List<Stack<String>> _applyOrder9001(List<Stack<String>> p, Order o) {
  var departure = p[o.item2];
  var arrival = p[o.item3];

  arrival.pushMulti(departure.popMulti(o.item1));

  p[o.item2] = departure;
  p[o.item3] = arrival;

  return p;
}

Order _createOrder(String line) {
  List<String> split = line.split(' ');
  return Order(int.parse(split[1]), int.parse(split[3]) - 1, int.parse(split[5]) - 1);
}

String _obtainResult(List<Stack<String>> stack) {
  String result = '';
  for (int i = 0; i < stack.length; i++) {
    result += stack[i].peek;
  }
  return result;
}

typedef Order = Tuple3<int, int, int>;

extension StackX<E> on Stack<E> {
  List<E> popMulti(int nb) {
    List<E> result = [];
    for (int i = 0; i < nb; i++) {
      result.add(pop());
    }
    return result.reversed.toList();
  }

  void pushMulti(List<E> value) {
    for (int i = 0; i < value.length; i++) {
      push(value[i]);
    }
  }
}
