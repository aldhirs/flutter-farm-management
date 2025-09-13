import 'package:intl/intl.dart';

class DateTimeUtils {
  DateTimeUtils._();

  static String getCurrentTimestamp() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    final iso = now.toIso8601String();
    return "${iso.substring(0, 23)}+07:00"; // cut to milliseconds + add offset
  }

  static String wibToUtcString(
    DateTime? date, {
    String pattern = "yyyy-MM-dd'T'HH:mm:ss'Z'",
  }) {
    if (date == null) return "";
    // WIB (UTC+7) → UTC (kurangi 7 jam)
    final utcDate = date.subtract(const Duration(hours: 7));
    return DateFormat(pattern, 'en_US').format(utcDate.toUtc());
  }
}
