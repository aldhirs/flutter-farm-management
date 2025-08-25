class ServerStatusCodeConstants {
  const ServerStatusCodeConstants._();

  static const success = 200;
  static const failure = 400;
  static const unauthorized = 401;
  static const serverError = 500;
  static const securityIssue = 132;
  static const turnstileIssue = 133;
  static const tooMuchRequestNewPassword = 134;

  static const verificationCodeDoesNotMatch = 123;
  static const verificationProcessFrozen = 124;
  static const verificationProcessBusy = 125;
  static const invalidSubmitRating = 116;

  static const chooseGroupFailed = 120;
}
