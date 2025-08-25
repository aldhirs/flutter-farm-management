class DurationConstants {
  const DurationConstants._();

  static const defaultListGridTransitionDuration = Duration(milliseconds: 500);
  static const defaultEventTransfomDuration = Duration(milliseconds: 500);
  static const defaultGeneralDialogTransitionDuration = Duration(milliseconds: 200);
  static const defaultSnackBarDuration = Duration(seconds: 3);
  static const defaultErrorVisibleDuration = Duration(seconds: 3);
  static const defaultSplashScreenDuration = Duration(milliseconds: 500);

  static const int SECOND_MILLIS = 1000;
  static const int MINUTE_MILLIS = 60 * SECOND_MILLIS;
  static const int HOUR_MILLIS = 60 * MINUTE_MILLIS;
  static const int DAY_MILLIS = 24 * HOUR_MILLIS;
  static const int MONTH_MILLIS = 30 * DAY_MILLIS;
  static const int YEAR_MILLIS = 365 * DAY_MILLIS;
}
