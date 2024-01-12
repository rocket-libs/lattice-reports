class Stat {
  final num current;
  final num previous;

  Stat({required this.current, required this.previous});

  bool get isPositive => current > previous;

  bool get isNegative => current < previous;

  bool get isNeutral => current == previous;

  num get difference => current - previous;
}
