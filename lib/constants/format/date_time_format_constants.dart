class DateTimeFormatConstants {
  DateTimeFormatConstants._();

  static const idLocale = 'id_ID';
  static const uiDateDmy = 'dd/MM/yyyy';
  static String uiDateDmySpace = 'dd MMM yyyy';
  static String uiDateEdmy = 'EEE, dd MMM yyyy';
  static const uiTimeHm = 'HH:mm';
  static const uiDateTime = 'dd/MM/yyyy, HH:mm';
  static const uiDateTextTime = 'd MMM yyyy, HH:mm';
  static const uiDateTextTimeLong = 'd MMMM yyyy, HH:mm';
  static const String defaultPatternDateTimeApp = "yyyy-MM-dd'T'HH:mm:ss'Z'";
  static const String defaultPatternDateTimeFirebase = 'yyyy-MM-dd HH:mm:ss';

  static const defaultTimezone = 'GMT+0700';

  static const appServerRequest = 'yyyy-MM-dd';
  static const localDmy = 'd MMM yyyy';
  static const localDmyLong = 'd MMMM yyyy';

  static const String? appServerResponse = null; // null <=> Iso8601
}
