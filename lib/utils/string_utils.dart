import 'dart:convert';

import 'package:farm/constants/date_constant.dart';
import 'package:intl/intl.dart';

extension StringExtensions on String {
  String plus(String other) {
    return this + other;
  }

  bool equalsIgnoreCase(String secondString) =>
      toLowerCase().contains(secondString.toLowerCase());

  String toTitleCase() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  bool isSvg() {
    return split('.').last.toLowerCase() == 'svg';
  }

  bool isPng() {
    return split('.').last.toLowerCase() == 'png';
  }

  String removeHtmlNbsp() {
    return replaceAll('<span class="ql-cursor">﻿</span>', '');
  }

  bool isHTML() {
    final RegExp htmlRegExp = RegExp(
      '<[^>]*>',
      multiLine: true,
      caseSensitive: false,
    );
    return htmlRegExp.hasMatch(this);
  }

  bool containsLatex() {
    RegExp regExp = RegExp(r'\$\$.*\$\$');
    return regExp.hasMatch(this);
  }

  String take(int nbChars) => substring(0, nbChars.clamp(0, length));

  String decodedBase64() {
    var decodeBytes = base64Decode(this);
    return String.fromCharCodes(decodeBytes);
  }

  String ellipsizeStartChar({int length = 32}) {
    if (this.length <= length) {
      return this;
    }
    return '...${substring(this.length - length)}';
  }

  String ellipsizeEndChar({int length = 120}) {
    if (this.length <= length) {
      return this;
    }
    return '${substring(0, length)}...';
  }

  String toLowerExceptFirst() {
    if (isEmpty) {
      return this;
    } else {
      return this[0] + substring(1).toLowerCase();
    }
  }

  DateTime parseToDate({
    String format = DateConstant.DATE_FULL_MONTH,
    String locale = 'id',
  }) {
    try {
      return DateFormat(format, locale).parse(this);
    } catch (e) {
      return DateTime(int.parse(this));
    }
  }

  String formatDateString({
    String format = DateConstant.DATE_FULL_MONTH,
    String newFormat = DateConstant.DATE_YEAR_FIRST,
  }) {
    if (isEmpty) {
      return this;
    }

    final inputFormat = DateFormat(format, 'id_ID');
    final dateTime = inputFormat.parse(this);

    final output = DateFormat(newFormat, 'id_ID').format(dateTime);
    return output;
  }
}
