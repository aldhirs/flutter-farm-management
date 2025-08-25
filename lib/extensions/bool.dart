extension DefaultBool on bool? {
  bool defaultFalse() => this ?? false;
  bool defaultTrue() => this ?? true;
}
