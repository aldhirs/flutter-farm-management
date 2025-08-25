extension DefaultZero on int? {
  int defaultZero() => this ?? 0;
  int withDefault(int value) => this ?? value;
}

extension IsTrue on int? {
  bool isTrue() => this == 1 ? true : false;
}

extension DefaultZeroDouble on double? {
  double defaultZero() => this ?? 0;
  double withDefault(double value) => this ?? value;
}
