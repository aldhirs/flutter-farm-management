class RegexPatternConstants {
  RegexPatternConstants._();

  static const String latexPattern = r'''(\${1,2})((?:\\.|[\s\S])*)\1''';
  static const String fileTypePattern = r'[^\\]*\.(\w+)$';
  static const String urlCheckPattern =
      r'((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?';
  static const String youtubeUrlPattern = r'^(https?\:\/\/)?(www\.youtube\.com|youtu\.be)\/.+$';
  static const String regexPin6Digit = '^\\d{6}\$';
  static const String reviewPattern = r'(?=.{5})(.*[a-zA-Z0-9].*)$';
  static const String usernamePattern = r'^[a-zA-Z0-9._-]+$';
  static const String namePattern = r'^[A-Za-z._-]+(?:\s[A-Za-z._-]+)*$';
}
