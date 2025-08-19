String parseEidFromRFID(String raw) {
  final regex = RegExp(r'EID:([0-9A-Z]+)');
  final match = regex.firstMatch(raw);
  return match?.group(1) ?? '';
}
