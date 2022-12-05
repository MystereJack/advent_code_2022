class Stack<E> {
  final List<E> _list;

  const Stack(List<E> list) : _list = list;

  bool get isEmpty => _list.isEmpty;

  bool get isNotEmpty => _list.isNotEmpty;

  E get peek => _list.last;

  E pop() => _list.removeLast();

  void push(E value) => _list.add(value);

  @override
  String toString() => _list.toString();
}
