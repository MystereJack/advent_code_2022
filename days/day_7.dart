import 'dart:io';

void main(List<String> arguments) {
  final lines = File('inputs/day_7.txt').readAsStringSync();

  Directory currentDirectory = Directory('/');
  RegExp regex = RegExp(r'(.+?) (.+)');
  final clearLines = lines.replaceAll('\$ ', '');

  regex.allMatches(clearLines).forEach((e) {
    String command = e[1]!;
    String value = e[2]!;
    switch (command) {
      case 'cd':
        {
          if (value[0] == '/') {
            currentDirectory.name = '/';
          } else if (value == '..') {
            currentDirectory = currentDirectory.parent!;
          } else {
            currentDirectory.addChild('${currentDirectory.name}$value/');
            currentDirectory =
                currentDirectory.children['${currentDirectory.name}$value/']!;
          }
        }
        break;
      case 'dir':
        {
          currentDirectory.addChild('${currentDirectory.name}$value/');
        }
        break;
      default:
        {
          currentDirectory.size += int.parse(command);
        }
    }
  });

  currentDirectory.root.updateTreeSize();

  print('1 : ${currentDirectory.root.solution1}');
  print('2 : ${currentDirectory.root.solution2}');
}

class Directory {
  String name;
  Directory? parent;
  Map<String, Directory> children = {};
  int size;
  int calculatedSize;

  Directory(
    this.name, {
    this.parent,
    this.size = 0,
    this.calculatedSize = 0,
  });

  Directory get root {
    if (parent == null) {
      return this;
    } else {
      return parent!.root;
    }
  }

  void addChild(String name) {
    children.putIfAbsent(name, () => Directory(name, parent: this));
  }

  int get solution1 {
    int result = calculatedSize <= 100000 ? calculatedSize : 0;
    for (var child in children.values) {
      result += child.solution1;
    }
    return result;
  }

  int get solution2 {
    int needed = -(70000000 - calculatedSize - 30000000);
    List<int> result = _recursiveSolution2(needed);
    result.sort();
    return result.first;
  }

  List<int> _recursiveSolution2(int needed) {
    List<int> result = [];

    if (calculatedSize >= needed) {
      result.add(calculatedSize);

      for (var child in children.values) {
        result += child._recursiveSolution2(needed);
      }
    }

    return result;
  }

  int _calculateSize() {
    int result = size;
    for (var child in children.values) {
      result += child._calculateSize();
    }
    return result;
  }

  void updateTreeSize() {
    calculatedSize = _calculateSize();
    for (var child in children.values) {
      child.updateTreeSize();
    }
  }
}
