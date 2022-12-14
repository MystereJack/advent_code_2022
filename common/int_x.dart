extension intX on int {
  Set<int> upTo(
    int max,
  ) =>
      {for (int i = this; i <= max; i++) i};

  Set<int> downTo(
    int max,
  ) =>
      {for (int i = max; i >= this; i--) i};

  bool isBetween(int from, int to) {
    return from <= this && this <= to;
  }
}
