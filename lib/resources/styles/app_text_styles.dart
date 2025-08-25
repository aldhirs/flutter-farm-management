import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppTextStyle format as follows:
/// s[fontSize][fontWeight][Color]
/// documentation about line height, you can read this post [https://api.flutter.dev/flutter/painting/TextStyle/height.html]
/// formula: line_height / height = fontSize * height
/// Use this TextStyle without responsive, below:
/// ```dart
/// AppTextStyles.heading1()
/// ```
/// Use this TextStyle with responsive based on device type, below:
/// ```dart
/// // body1 is active in the mobile device type
/// AppTextStyles.body1(
///   tabletPortrait: AppTextStyles.heading3(), // active in the tablet portrait device type
///   tabletLandscape: AppTextStyles.heading1(), // active in the tablet landscape device type
/// );
/// ```
@Deprecated('outdated. Use class TextStyles instead')
class AppTextStyles {
  AppTextStyles._();

  static const _defaultLetterSpacing = 0.0;

  static TextStyle _baseInterFontStyle() => GoogleFonts.inter(
    color: AppColors.current.text100,
    letterSpacing: _defaultLetterSpacing,
  );

  // heading
  static TextStyle heading1({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d32,
        fontWeight: FontWeight.w800,
        height: 1.5, // line height 16sp
      ),
      tabletPotrait,
      tabletLandscape,
    ),
  );

  static TextStyle heading2({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d32,
        fontWeight: FontWeight.w600,
        height: 1.5, // line height 48sp
      ),
      tabletPotrait,
      tabletLandscape,
    ),
  );

  static TextStyle heading3({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d24,
        fontWeight: FontWeight.w600,
        height: 1.33, // line height 32sp
      ),
      tabletPotrait,
      tabletLandscape,
    ),
  );

  static TextStyle heading4({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d20,
        fontWeight: FontWeight.w600,
        height: 1.2, // line height 24sp
      ),
      tabletPotrait,
      tabletLandscape,
    ),
  );

  // body
  static TextStyle body1({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d18,
        fontWeight: FontWeight.w600,
        height: 1.33, // line height 24sp
      ),
      tabletPotrait,
      tabletLandscape,
    ),
  );

  static TextStyle body2({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d16,
        fontWeight: FontWeight.w600,
        height: 1.5,
      ), // line height 24sp
      tabletPotrait,
      tabletLandscape,
    ),
  );

  // it is the same with paragraph5
  static TextStyle body3({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d14,
        fontWeight: FontWeight.normal,
        height: 1.42,
      ), // line height 20sp
      tabletPotrait,
      tabletLandscape,
    ),
  );

  // paragraph
  static TextStyle paragraph1({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d18,
        fontWeight: FontWeight.w600,
        height: 1.38,
      ), // line height 25sp
      tabletPotrait,
      tabletLandscape,
    ),
  );

  static TextStyle paragraph2({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d18,
        fontWeight: FontWeight.normal,
        height: 1.38,
      ), // line height 25sp
      tabletPotrait,
      tabletLandscape,
    ),
  );

  static TextStyle paragraph3({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d16,
        fontWeight: FontWeight.normal,
        height: 1.37,
      ), // line height 22sp
      tabletPotrait,
      tabletLandscape,
    ),
  );

  static TextStyle paragraph4({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d14,
        fontWeight: FontWeight.w600,
        height: 1.42,
      ), // line height 20sp
      tabletPotrait,
      tabletLandscape,
    ),
  );

  static TextStyle paragraph5({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d14,
        fontWeight: FontWeight.normal,
        height: 1.42,
      ), // line height 20sp
      tabletPotrait,
      tabletLandscape,
    ),
  );

  static TextStyle paragraph6({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d12,
        fontWeight: FontWeight.normal,
        height: 1.41,
      ), // line height 17sp
      tabletPotrait,
      tabletLandscape,
    ),
  );

  // label
  static TextStyle label1({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d14,
        fontWeight: FontWeight.w600,
        height: 1.71,
      ), // line height 24sp
      tabletPotrait,
      tabletLandscape,
    ),
  );

  static TextStyle label2({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d14,
        fontWeight: FontWeight.w500,
        height: 1.71,
      ), // line height 24sp
      tabletPotrait,
      tabletLandscape,
    ),
  );

  static TextStyle label3({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d14,
        fontWeight: FontWeight.normal,
        height: 1.71,
      ), // line height 24sp
      tabletPotrait,
      tabletLandscape,
    ),
  );

  static TextStyle label4({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d12,
        fontWeight: FontWeight.w600,
        height: 1.33,
      ), // line height 16sp
      tabletPotrait,
      tabletLandscape,
    ),
  );

  static TextStyle label5({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d12,
        fontWeight: FontWeight.normal,
        height: 1.33,
      ), // line height 16sp
      tabletPotrait,
      tabletLandscape,
    ),
  );

  static TextStyle label6({
    TextStyle? tabletPotrait,
    TextStyle? tabletLandscape,
  }) => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      const TextStyle(
        fontSize: Dimens.d10,
        fontWeight: FontWeight.w700,
        height: 1.6,
      ), // line height 16sp
      tabletPotrait,
      tabletLandscape,
    ),
  );
}
