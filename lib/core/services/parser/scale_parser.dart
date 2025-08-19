String parseWeightFromScale(String raw) {
  final regex = RegExp(r'W:([0-9]+\.?[0-9]*)');
  final match = regex.firstMatch(raw);
  return match?.group(1) ?? '';
}
