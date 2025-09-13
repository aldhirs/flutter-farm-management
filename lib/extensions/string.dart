import 'package:dartx/dartx.dart';
import 'package:farm/constants/date_constant.dart';
import 'package:intl/intl.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }
}

extension DefaultValue on String? {
  String defaultValue(String value) {
    return isNullOrEmpty ? value : this!;
  }
}

extension PasswordValidator on String {
  bool isValidPassword() {
    String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$';
    return RegExp(pattern).hasMatch(this);
  }
}
