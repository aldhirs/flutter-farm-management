import 'package:farm/constants/date_constant.dart';
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

  static String parseToString(
    DateTime? date, {
    String pattern = "yyyy-MM-dd'T'HH:mm:ss'Z'",
  }) {
    if (date == null) return "";
    return DateFormat(pattern, 'en_US').format(date);
  }

  /// Parse string ISO8601 ke DateTime, lalu convert ke WIB
  static DateTime parseToWib(String isoString) {
    final utcDate = DateTime.parse(isoString); // otomatis UTC karena ada 'Z'
    return utcDate.toUtc().add(const Duration(hours: 7)); // ke WIB
  }

  /// Format string ISO8601 ke custom format dalam WIB
  static String formatToWib(
    String isoString, {
    String pattern = DateConstant.DATETIME_FULL_MONTH,
  }) {
    final wibDate = parseToWib(isoString);
    return DateFormat(pattern, 'id_ID').format(wibDate);
  }
}
