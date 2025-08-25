import 'package:flutter/material.dart';

enum ButtonSize {
  small(size: 36, padding: 6),
  medium(size: 44, padding: 10),
  large(size: 48, padding: 12),
  extraLarge(size: 56, padding: 16);

  const ButtonSize({required this.size, required this.padding});

  final double size;
  final double padding;
}

enum ButtonType {
  primary(
    backgroundColor: Color(0xFF351b0a),
    textColor: Colors.white,
    borderColor: Colors.transparent,
  ),
  secondary(
    backgroundColor: Colors.white,
    textColor: Color(0xFF351b0a),
    borderColor: Color(0xFF351b0a),
  ),
  secondaryDefault(
    backgroundColor: Colors.white,
    textColor: Color(0xFF333333),
    borderColor: Color(0xFFE0E0E0),
  ),
  dangerPrimary(
    backgroundColor: Color(0xFFFF3838),
    textColor: Colors.white,
    borderColor: Colors.transparent,
  ),
  ghost(
    backgroundColor: Colors.transparent,
    textColor: Color(0xFF351b0a),
    borderColor: Colors.transparent,
  ),
  disabled(
    backgroundColor: Color(0xFFE0E0E0),
    textColor: Color(0xFF676767),
    borderColor: Colors.transparent,
  ),
  disabledDanger(
    backgroundColor: Color(0xFFFF9C87),
    textColor: Colors.white,
    borderColor: Colors.transparent,
  ),
  disabledGhost(
    backgroundColor: Colors.transparent,
    textColor: Color(0xFF676767),
    borderColor: Colors.transparent,
  );

  const ButtonType({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });

  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
}

enum CircularLoadingSize {
  small(size: 12),
  medium(size: 16),
  large(size: 24),
  extraLarge(size: 32);

  const CircularLoadingSize({required this.size});

  final double size;
}

enum AnimatedLoadingType {
  pen_rotate('assets/animations/loading_pen_rotating.json'),
  pen_write('assets/animations/loading_pen_write.json'),
  loading_progress('assets/animations/loading_progress.json');

  final String value;

  const AnimatedLoadingType(this.value);

  static AnimatedLoadingType getEnum(String? name) {
    for (var enumValue in AnimatedLoadingType.values) {
      if (enumValue.value.toLowerCase() == name?.toLowerCase()) {
        return enumValue;
      }
    }
    return AnimatedLoadingType.pen_rotate;
  }
}

enum TickerViewType {
  success(
    backgroundColor: Color(0xFFDCFCE3),
    actionTextColor: Color(0xFF279780),
    icon: 'assets/icons/ic_ticker_success.svg',
  ),
  info(
    backgroundColor: Color(0xFFeaf7ff),
    actionTextColor: Color(0xFF006ad3),
    icon: 'assets/icons/ic_ticker_info.svg',
  ),
  danger(
    backgroundColor: Color(0xFFFFE4D7),
    actionTextColor: Color(0xFFFF3838),
    icon: 'assets/icons/ic_ticker_danger.svg',
  ),
  warning(
    backgroundColor: Color(0xFFFEF9D1),
    actionTextColor: Color(0xFFA96004),
    icon: 'assets/icons/ic_ticker_warning.svg',
  );

  final Color backgroundColor;
  final Color actionTextColor;
  final String icon;

  const TickerViewType({
    required this.backgroundColor,
    required this.actionTextColor,
    required this.icon,
  });
}
