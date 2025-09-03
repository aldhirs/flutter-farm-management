class DateTimeUtils {
  DateTimeUtils._();

  static String getCurrentTimestamp() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    final iso = now.toIso8601String();
    return "${iso.substring(0, 23)}+07:00"; // cut to milliseconds + add offset
  }
}
