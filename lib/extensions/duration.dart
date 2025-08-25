extension FormatDuration on Duration {
  String toHMSString({bool showHours = false}) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(inHours.remainder(60));
    final minutes = twoDigits(inMinutes.remainder(60));
    final seconds = twoDigits(inSeconds.remainder(60));
    if (inHours > 0 || showHours) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}
