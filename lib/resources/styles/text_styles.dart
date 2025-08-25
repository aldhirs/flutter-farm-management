import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// TextStyles is new version of the AppTextStyles.
/// TextStyle format as follows:
/// s[fontSize][fontWeight][Color]
/// documentation about line height, you can read this post [https://api.flutter.dev/flutter/painting/TextStyle/height.html]
/// formula: line_height / height = fontSize * height
/// Use this TextStyle without responsive, below:
/// ```dart
/// TextStyles.heading1()
/// ```
/// formula to find result the line height is: height * font size
/// https://medium.com/@rajflutter/implementing-figma-line-height-in-flutter-textstyle-a-complete-guide-1b09d1f214eb#:~:text=In%20Flutter%2C%20line%20height%20is,How%20height%20Works%3A&text=The%20height%20property%20is%20a%20multiplier%20applied%20to%20the%20fontSize.
/// ```
class TextStyles {
  TextStyles._();

  static const _defaultLetterSpacing = 0.0;

  static TextStyle _baseInterFontStyle() => GoogleFonts.inter(
    color: AppColors.current.text100,
    letterSpacing: _defaultLetterSpacing,
  );

  // --- RESPONSIVE
  static TextStyle heading1() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _heading1Mobile(),
      _heading1Tablet(),
      _heading1Desktop(),
    ),
  );
  static TextStyle heading2() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _heading2Mobile(),
      _heading2Tablet(),
      _heading2Desktop(),
    ),
  );
  static TextStyle heading3() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _heading3Mobile(),
      _heading3Tablet(),
      _heading3Desktop(),
    ),
  );
  static TextStyle heading4() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _heading4Mobile(),
      _heading4Tablet(),
      _heading4Desktop(),
    ),
  );
  static TextStyle heading5() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _heading5Mobile(),
      _heading5Tablet(),
      _heading5Desktop(),
    ),
  );
  static TextStyle heading6() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _heading6Mobile(),
      _heading6Tablet(),
      _heading6Desktop(),
    ),
  );
  static TextStyle body1() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _body1Mobile(),
      _body1Tablet(),
      _body1Desktop(),
    ),
  );
  static TextStyle body2() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _body2Mobile(),
      _body2Tablet(),
      _body2Desktop(),
    ),
  );
  static TextStyle body3() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _body3Mobile(),
      _body3Tablet(),
      _body3Desktop(),
    ),
  );
  static TextStyle paragraph1() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _paragraph1Mobile(),
      _paragraph1Tablet(),
      _paragraph1Desktop(),
    ),
  );
  static TextStyle paragraph2() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _paragraph2Mobile(),
      _paragraph2Tablet(),
      _paragraph2Desktop(),
    ),
  );
  static TextStyle paragraph3() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _paragraph3Mobile(),
      _paragraph3Tablet(),
      _paragraph3Desktop(),
    ),
  );
  static TextStyle label1() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _label1Mobile(),
      _label1Tablet(),
      _label1Desktop(),
    ),
  );
  static TextStyle label2() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _label2Mobile(),
      _label2Tablet(),
      _label2Desktop(),
    ),
  );
  static TextStyle label3() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _label3Mobile(),
      _label3Tablet(),
      _label3Desktop(),
    ),
  );
  static TextStyle label4() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _label4Mobile(),
      _label4Tablet(),
      _label4Desktop(),
    ),
  );
  static TextStyle label5() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _label5Mobile(),
      _label5Tablet(),
      _label5Desktop(),
    ),
  );
  static TextStyle label6() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _label6Mobile(),
      _label6Tablet(),
      _label6Desktop(),
    ),
  );
  static TextStyle button1() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _button1Mobile(),
      _button1Tablet(),
      _button1Desktop(),
    ),
  );
  static TextStyle button2() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _button2Mobile(),
      _button2Tablet(),
      _button2Desktop(),
    ),
  );
  static TextStyle button3() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _button3Mobile(),
      _button3Tablet(),
      _button3Desktop(),
    ),
  );
  static TextStyle notifTitle() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _notifTitleMobile(),
      _notifTitleTablet(),
      _notifTitleDesktop(),
    ),
  );
  static TextStyle notifBody() => _baseInterFontStyle().merge(
    AppDimen.current.responsiveTextStyle(
      _notifBodyMobile(),
      _notifBodyTablet(),
      _notifBodyDesktop(),
    ),
  );
  // END RESPONSIVE

  // MOBILE
  static TextStyle _heading1Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d32,
      fontWeight: FontWeight.w700,
      height: 1.375, // line height 44sp
    ),
  );
  static TextStyle _heading2Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d28,
      fontWeight: FontWeight.w700,
      height: 1.428, // line height 40sp
    ),
  );
  static TextStyle _heading3Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d24,
      fontWeight: FontWeight.w600,
      height: 1.5, // line height 36sp
    ),
  );
  static TextStyle _heading4Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d20,
      fontWeight: FontWeight.w600,
      height: 1.6, // line height 32sp
    ),
  );
  static TextStyle _heading5Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d18,
      fontWeight: FontWeight.w600,
      height: 1.555, // line height 28sp
    ),
  );
  static TextStyle _heading6Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d16,
      fontWeight: FontWeight.w600,
      height: 1.5, // line height 24sp
    ),
  );
  static TextStyle _body1Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d16,
      fontWeight: FontWeight.w600,
      height: 1.5, // line height 24sp
    ),
  );
  static TextStyle _body2Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.w600,
      height: 1.428, // line height 20sp
    ),
  );
  static TextStyle _body3Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d12,
      fontWeight: FontWeight.w600,
      height: 1.333, // line height 16sp
    ),
  );
  static TextStyle _paragraph1Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d16,
      fontWeight: FontWeight.normal,
      height: 1.5, // line height 24sp
    ),
  );
  static TextStyle _paragraph2Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.normal,
      height: 1.428, // line height 20sp
    ),
  );
  static TextStyle _paragraph3Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d12,
      fontWeight: FontWeight.normal,
      height: 1.333, // line height 16sp
    ),
  );
  static TextStyle _label1Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.normal,
      height: 1.714, // line height 24sp
    ),
  );
  static TextStyle _label2Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d12,
      fontWeight: FontWeight.w600,
      height: 1.666, // line height 20sp
    ),
  );
  static TextStyle _label3Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d10,
      fontWeight: FontWeight.normal,
      height: 1.6, // line height 16sp
    ),
  );
  static TextStyle _label4Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d10,
      fontWeight: FontWeight.w700,
      height: 1.6, // line height 16sp
    ),
  );
  static TextStyle _label5Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d10,
      fontWeight: FontWeight.w600,
      height: 1.6, // line height 16sp
    ),
  );
  static TextStyle _label6Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.w500,
      height: 1.714, // line height 24sp
    ),
  );
  static TextStyle _button1Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d16,
      fontWeight: FontWeight.w600,
      height: 1.5, // line height 24sp
    ),
  );
  static TextStyle _button2Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.w600,
      height: 1.428, // line height 20sp
    ),
  );
  static TextStyle _button3Mobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d12,
      fontWeight: FontWeight.w600,
      height: 1.333, // line height 16sp
    ),
  );
  static TextStyle _notifTitleMobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.w600,
      height: 1.571, // line height 22sp
    ),
  );
  static TextStyle _notifBodyMobile() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d12,
      fontWeight: FontWeight.normal,
      height: 1.5, // line height 18sp
    ),
  );

  // TABLET
  static TextStyle _heading1Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d40,
      fontWeight: FontWeight.w700,
      height: 1.75, // line height 60sp
    ),
  );
  static TextStyle _heading2Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d32,
      fontWeight: FontWeight.w700,
      height: 1.5, // line height 48sp
    ),
  );
  static TextStyle _heading3Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d28,
      fontWeight: FontWeight.w600,
      height: 1.5, // line height 42sp
    ),
  );
  static TextStyle _heading4Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d24,
      fontWeight: FontWeight.w600,
      height: 1.565, // line height 36sp
    ),
  );
  static TextStyle _heading5Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d20,
      fontWeight: FontWeight.w600,
      height: 1.5, // line height 30sp
    ),
  );
  static TextStyle _heading6Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d18,
      fontWeight: FontWeight.w600,
      height: 1.444, // line height 26sp
    ),
  );
  static TextStyle _body1Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d16,
      fontWeight: FontWeight.w600,
      height: 1.5, // line height 24sp
    ),
  );
  static TextStyle _body2Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.w600,
      height: 1.428, // line height 20sp
    ),
  );
  static TextStyle _body3Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d12,
      fontWeight: FontWeight.w600,
      height: 1.333, // line height 16sp
    ),
  );
  static TextStyle _paragraph1Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d16,
      fontWeight: FontWeight.normal,
      height: 1.5, // line height 24sp
    ),
  );
  static TextStyle _paragraph2Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.normal,
      height: 1.428, // line height 20sp
    ),
  );
  static TextStyle _paragraph3Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d12,
      fontWeight: FontWeight.normal,
      height: 1.333, // line height 16sp
    ),
  );
  static TextStyle _label1Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.normal,
      height: 1.714, // line height 24sp
    ),
  );
  static TextStyle _label2Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d12,
      fontWeight: FontWeight.w600,
      height: 1.428, // line height 20sp
    ),
  );
  static TextStyle _label3Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d12,
      fontWeight: FontWeight.normal,
      height: 1.333, // line height 16sp
    ),
  );
  static TextStyle _label4Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d10,
      fontWeight: FontWeight.w700,
      height: 1.6, // line height 16sp
    ),
  );
  static TextStyle _label5Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d12,
      fontWeight: FontWeight.w600,
      height: 1.333, // line height 16sp
    ),
  );
  static TextStyle _label6Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.w500,
      height: 1.714, // line height 24sp
    ),
  );
  static TextStyle _button1Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d16,
      fontWeight: FontWeight.w600,
      height: 1.5, // line height 24sp
    ),
  );
  static TextStyle _button2Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.w600,
      height: 1.428, // line height 20sp
    ),
  );
  static TextStyle _button3Tablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d12,
      fontWeight: FontWeight.w600,
      height: 1.333, // line height 16sp
    ),
  );
  static TextStyle _notifTitleTablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d16,
      fontWeight: FontWeight.w600,
      height: 1.5, // line height 24sp
    ),
  );
  static TextStyle _notifBodyTablet() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.normal,
      height: 1.428, // line height 20sp
    ),
  );

  // DESKTOP
  static TextStyle _heading1Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d48,
      fontWeight: FontWeight.w700,
      height: 1.5, // line height 72sp
    ),
  );
  static TextStyle _heading2Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d40,
      fontWeight: FontWeight.w700,
      height: 1.5, // line height 60sp
    ),
  );
  static TextStyle _heading3Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d32,
      fontWeight: FontWeight.w600,
      height: 1.5, // line height 48sp
    ),
  );
  static TextStyle _heading4Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d28,
      fontWeight: FontWeight.w600,
      height: 1.5, // line height 42sp
    ),
  );
  static TextStyle _heading5Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d24,
      fontWeight: FontWeight.w600,
      height: 1.333, // line height 32sp
    ),
  );
  static TextStyle _heading6Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d20,
      fontWeight: FontWeight.w600,
      height: 1.3, // line height 26sp
    ),
  );
  static TextStyle _body1Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d18,
      fontWeight: FontWeight.w600,
      height: 1.555, // line height 28sp
    ),
  );
  static TextStyle _body2Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d16,
      fontWeight: FontWeight.w600,
      height: 1.5, // line height 24sp
    ),
  );
  static TextStyle _body3Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.w600,
      height: 1.428, // line height 20sp
    ),
  );
  static TextStyle _paragraph1Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d18,
      fontWeight: FontWeight.normal,
      height: 1.555, // line height 28sp
    ),
  );
  static TextStyle _paragraph2Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d16,
      fontWeight: FontWeight.normal,
      height: 1.5, // line height 24sp
    ),
  );
  static TextStyle _paragraph3Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.normal,
      height: 1.428, // line height 20sp
    ),
  );
  static TextStyle _label1Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.normal,
      height: 1.714, // line height 24sp
    ),
  );
  static TextStyle _label2Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.w600,
      height: 1.428, // line height 20sp
    ),
  );
  static TextStyle _label3Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d12,
      fontWeight: FontWeight.normal,
      height: 1.333, // line height 16sp
    ),
  );
  static TextStyle _label4Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d10,
      fontWeight: FontWeight.w700,
      height: 1.6, // line height 16sp
    ),
  );
  static TextStyle _label5Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d12,
      fontWeight: FontWeight.w600,
      height: 1.333, // line height 16sp
    ),
  );
  static TextStyle _label6Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.w500,
      height: 1.714, // line height 24sp
    ),
  );
  static TextStyle _button1Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d18,
      fontWeight: FontWeight.w600,
      height: 1.555, // line height 28sp
    ),
  );
  static TextStyle _button2Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d16,
      fontWeight: FontWeight.w600,
      height: 1.5, // line height 24sp
    ),
  );
  static TextStyle _button3Desktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.w600,
      height: 1.428, // line height 20sp
    ),
  );
  static TextStyle _notifTitleDesktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d16,
      fontWeight: FontWeight.w600,
      height: 1.5, // line height 24sp
    ),
  );
  static TextStyle _notifBodyDesktop() => _baseInterFontStyle().merge(
    const TextStyle(
      fontSize: Dimens.d14,
      fontWeight: FontWeight.normal,
      height: 1.428, // line height 20sp
    ),
  );
}
