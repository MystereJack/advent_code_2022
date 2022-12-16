import 'dart:io';

import '../common/vector2.dart';

String regex = r'Sensor at x=(\d+), y=(\d+): closest beacon is at x=([-]{0,1}\d+), y=(\d+)';
const distanceToCheck = 2000000;
void main(List<String> arguments) {
  final grid = File('inputs/day_15.txt')
      .readAsStringSync()
      .split('\n')
      .where((el) => el.isNotEmpty)
      .fold(<int>{}, _populateGrid);

  print(grid.length - 1);
}

Set<int> _populateGrid(Set<int> coordinates, String line) {
  final m = RegExp(regex).allMatches(line).isNotEmpty
      ? RegExp(regex).allMatches(line).elementAt(0)
      : null;

  if (m == null) {
    return coordinates;
  }

  Vector2 sensor = Vector2(int.parse(m.group(1)!), int.parse(m.group(2)!));
  Vector2 beacon = Vector2(int.parse(m.group(3)!), int.parse(m.group(4)!));

  int manathanDistance = (sensor.x - beacon.x).abs() + (sensor.y - beacon.y).abs();

  // Si le sensor se trouve sur une ligne dont l'onde couvrira la ligne à checker
  if (sensor.y < distanceToCheck && sensor.y + manathanDistance >= distanceToCheck) {
    final yToGoal = distanceToCheck - sensor.y;
    for (int xOnY = sensor.x - (manathanDistance - yToGoal);
        xOnY <= sensor.x + (manathanDistance - yToGoal);
        xOnY++) {
      coordinates.add(xOnY);
    }
  }
  if (sensor.y > distanceToCheck && sensor.y - manathanDistance <= distanceToCheck) {
    final yToGoal = sensor.y - distanceToCheck;
    for (int xOnY = sensor.x - (manathanDistance - yToGoal);
        xOnY <= sensor.x + (manathanDistance - yToGoal);
        xOnY++) {
      coordinates.add(xOnY);
    }
  }

  return coordinates;
}
