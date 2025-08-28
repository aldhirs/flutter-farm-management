// ignore_for_file: avoid_hardcoded_colors
import 'package:farm/resources/styles/app_themes.dart';
import 'package:flutter/material.dart';

class AppColors {
  const AppColors({
    required this.primaryColor,
    required this.cursorColor,
    required this.persianBlue600,
    required this.persianBlue200,
    required this.persianBlue700,
    required this.neutral100,
    required this.black,
    required this.text100,
    required this.text200,
    required this.text300,
    required this.neutral500,
    required this.neutral200,
    required this.neutral800,
    required this.neutral900,
    required this.purple,
    required this.white100,
    required this.redRidingHood,
    required this.persianBlue500,
    required this.bluePastel,
    required this.grey,
    required this.green,
    required this.gamboge400,
    required this.eucalyptus600,
    required this.eucalyptus200,
    required this.deadPixel,
    required this.crimson200,
    required this.crimson500,
    required this.brilliantWhite50,
    required this.neutral700,
    required this.neutral400,
    required this.crimson300,
    required this.persianBlue300,
    required this.persianBlue400,
    required this.deepLemon200,
    required this.black50,
    required this.neutral300,
    required this.gamboge500,
    required this.darkSpell,
    required this.gamboge600,
    required this.gamboge300,
    required this.graphiteBlack,
    required this.eucalyptus700,
    required this.gamboge200,
    required this.deepLemon400,
    required this.persianBlue800,
    required this.neutral600,
    required this.cobalt400,
    required this.eucalyptus800,
    required this.eucalyptus500,
    required this.eucalyptus400,
    required this.eucalyptus300,
    required this.gamboge800,
    required this.gamboge700,
    required this.cobalt800,
    required this.cobalt700,
    required this.cobalt600,
    required this.cobalt500,
    required this.cobalt300,
    required this.cobalt200,
    required this.crimson800,
    required this.crimson700,
    required this.crimson600,
    required this.crimson400,
    required this.deepLemon800,
    required this.deepLemon700,
    required this.deepLemon600,
    required this.deepLemon500,
    required this.deepLemon550,
    required this.deepLemon300,
    required this.mint800,
    required this.mint700,
    required this.mint600,
    required this.mint500,
    required this.mint400,
    required this.mint300,
    required this.mint200,
    required this.royalNavy100,
    required this.royalNavy300,
    required this.royalNavy400,
    required this.royalNavy500,
    required this.royalNavy600,
    required this.royalNavy700,
    required this.royalNavy900,
    required this.surface,
  });

  static late AppColors current;

  final Color primaryColor;
  final Color cursorColor;
  final Color persianBlue200;
  final Color persianBlue300;
  final Color persianBlue400;
  final Color persianBlue500;
  final Color persianBlue600;
  final Color persianBlue700;
  final Color persianBlue800;
  final Color neutral100;
  final Color black;
  final Color text100;
  final Color text200;
  final Color text300;
  final Color neutral500;
  final Color neutral200;
  final Color neutral800;
  final Color neutral900;
  final Color purple;
  final Color white100;
  final Color redRidingHood;
  final Color bluePastel;
  final Color green;
  final Color grey;
  final Color eucalyptus600;
  final Color eucalyptus200;
  final Color deadPixel;
  final Color crimson200;
  final Color crimson500;
  final Color brilliantWhite50;
  final Color neutral700;
  final Color neutral400;
  final Color crimson300;
  final Color deepLemon200;
  final Color gamboge200;
  final Color gamboge300;
  final Color gamboge400;
  final Color gamboge500;
  final Color gamboge600;
  final Color neutral300;
  final Color neutral600;
  final Color black50;
  final Color graphiteBlack;
  final Color darkSpell;
  final Color cobalt400;
  final Color eucalyptus800;
  final Color eucalyptus700;
  final Color eucalyptus500;
  final Color eucalyptus400;
  final Color eucalyptus300;
  final Color gamboge800;
  final Color gamboge700;
  final Color cobalt800;
  final Color cobalt700;
  final Color cobalt600;
  final Color cobalt500;
  final Color cobalt300;
  final Color cobalt200;
  final Color crimson800;
  final Color crimson700;
  final Color crimson600;
  final Color crimson400;
  final Color deepLemon300;
  final Color deepLemon400;
  final Color deepLemon500;
  final Color deepLemon550;
  final Color deepLemon600;
  final Color deepLemon800;
  final Color deepLemon700;
  final Color mint800;
  final Color mint700;
  final Color mint600;
  final Color mint500;
  final Color mint400;
  final Color mint300;
  final Color mint200;
  final Color royalNavy100;
  final Color royalNavy300;
  final Color royalNavy400;
  final Color royalNavy500;
  final Color royalNavy600;
  final Color royalNavy700;
  final Color royalNavy900;
  final Color surface;

  static const defaultAppColor = AppColors(
    primaryColor: Color(0xFF003972),
    cursorColor: Color(0xFF003972),
    persianBlue600: Color(0xFF191B99),
    persianBlue700: Color(0xFF111280),
    persianBlue200: Color(0xFFEBEDFE),
    neutral100: Colors.white,
    black: Colors.black,
    text100: Color(0xFF333333),
    text200: Color(0xFF584B4C),
    text300: Color(0xFF676767),
    neutral500: Color(0xFFE0E0E0),
    neutral200: Color(0xFFFAFAFA),
    neutral800: Color(0xFF828282),
    neutral900: Color(0xFF3A3A3A),
    purple: Color(0xFFD8D8FF),
    white100: Color(0xFFCECECE),
    redRidingHood: Color(0xFFFB2416),
    persianBlue500: Color(0xFF2325B3),
    bluePastel: Color(0xFFD8D8FF),
    grey: Color(0xFFCECECE),
    green: Color(0xFF47996B),
    gamboge400: Color(0xFFF3B943),
    eucalyptus600: Color(0xFF39B58F),
    eucalyptus200: Color(0xFFDCFCE3),
    deadPixel: Color(0xFF3A3A3A),
    crimson200: Color(0xFFFFE4D7),
    crimson500: Color(0xFFFF3838),
    neutral700: Color(0xFFBDBDBD),
    neutral400: Color(0xFFF5F6FA),
    crimson300: Color(0xFFFF9C87),
    persianBlue400: Color(0xFF5354D1),
    persianBlue800: Color(0xFF060755),
    deepLemon200: Color(0xFFFEF9D1),
    gamboge200: Color(0xFFFEF3CC),
    deepLemon400: Color(0xFFFDDE53),
    gamboge300: Color(0xFFF9CE68),
    gamboge500: Color(0xFFEC9808),
    gamboge600: Color(0xFFCA7A05),
    eucalyptus700: Color(0xFF279780),
    neutral300: Color(0xFFF2F2F2),
    black50: Color(0x80000000),
    graphiteBlack: Color(0xFF25282B),
    darkSpell: Color(0xFF2E3B4C),
    brilliantWhite50: Color(0x80EBEDFE),
    persianBlue300: Color(0xFF787AE8),
    neutral600: Color(0xFFC0C0C0),
    cobalt400: Color(0xFF4894F5),
    eucalyptus800: Color(0xFF0E6564),
    eucalyptus500: Color(0xFF4ED39D),
    eucalyptus400: Color(0xFF78E4AD),
    eucalyptus300: Color(0xFF96F1BA),
    gamboge800: Color(0xFF713701),
    gamboge700: Color(0xFFA96004),
    cobalt800: Color(0xFF021D72),
    cobalt700: Color(0xFF073BAC),
    cobalt600: Color(0xFF0A50CD),
    cobalt500: Color(0xFF0F68EF),
    cobalt300: Color(0xFF6DB0FA),
    cobalt200: Color(0xFFCEE9FE),
    crimson800: Color(0xFF7A0A31),
    crimson700: Color(0xFFB71C37),
    crimson600: Color(0xFFDB2838),
    crimson400: Color(0xFFFF7669),
    deepLemon800: Color(0xFF795705),
    deepLemon700: Color(0xFFB68B0D),
    deepLemon600: Color(0xFFD9AC13),
    deepLemon500: Color(0xFFFDCE1B),
    deepLemon550: Color(0xFFFDCF1A),
    deepLemon300: Color(0xFFFEE776),
    mint800: Color(0xFF013F4E),
    mint700: Color(0xFF047475),
    mint600: Color(0xFF058C80),
    mint500: Color(0xFF08A387),
    mint400: Color(0xFF39C7A0),
    mint300: Color(0xFF61E3B3),
    mint200: Color(0xFFCAFADF),
    royalNavy100: Color(0xFFeaf7ff),
    royalNavy300: Color(0xFF60b8f1),
    royalNavy400: Color(0xFF3997e4),
    royalNavy500: Color(0xFF003972),
    royalNavy600: Color(0xFF0052b5),
    royalNavy700: Color(0xFF003d97),
    royalNavy900: Color(0xFF001e65),
    surface: Color(0xFFF5F8FA),
  );

  static const darkThemeColor = AppColors(
    primaryColor: Color(0xFF003972),
    cursorColor: Color(0xFF003972),
    persianBlue600: Color(0xFF191B99),
    persianBlue700: Color(0xFF111280),
    persianBlue200: Color(0xFFEBEDFE),
    neutral100: Colors.white,
    black: Colors.black,
    text100: Color(0xFF333333),
    text200: Color(0xFF584B4C),
    text300: Color(0xFF676767),
    neutral500: Color(0xFFE0E0E0),
    neutral200: Color(0xFFFAFAFA),
    neutral800: Color(0xFF828282),
    neutral900: Color(0xFF3A3A3A),
    purple: Color(0xFFD8D8FF),
    white100: Color(0xFFCECECE),
    redRidingHood: Color(0xFFFB2416),
    persianBlue500: Color(0xFF2325B3),
    bluePastel: Color(0xFFD8D8FF),
    grey: Color(0xFFCECECE),
    green: Color(0xFF47996B),
    gamboge400: Color(0xFFF3B943),
    eucalyptus600: Color(0xFF39B58F),
    eucalyptus200: Color(0xFFDCFCE3),
    deadPixel: Color(0xFF3A3A3A),
    crimson200: Color(0xFFFFE4D7),
    crimson500: Color(0xFFFF3838),
    neutral700: Color(0xFFBDBDBD),
    neutral400: Color(0xFFF5F6FA),
    crimson300: Color(0xFFFF9C87),
    persianBlue400: Color(0xFF5354D1),
    persianBlue800: Color(0xFF060755),
    deepLemon200: Color(0xFFFEF9D1),
    gamboge200: Color(0xFFFEF3CC),
    deepLemon400: Color(0xFFFDDE53),
    gamboge300: Color(0xFFF9CE68),
    gamboge500: Color(0xFFEC9808),
    gamboge600: Color(0xFFCA7A05),
    eucalyptus700: Color(0xFF279780),
    neutral300: Color(0xFFF2F2F2),
    black50: Color(0x80000000),
    graphiteBlack: Color(0xFF25282B),
    darkSpell: Color(0xFF2E3B4C),
    brilliantWhite50: Color(0x80EBEDFE),
    persianBlue300: Color(0xFF787AE8),
    neutral600: Color(0xFFC0C0C0),
    cobalt400: Color(0xFF4894F5),
    eucalyptus800: Color(0xFF0E6564),
    eucalyptus500: Color(0xFF4ED39D),
    eucalyptus400: Color(0xFF78E4AD),
    eucalyptus300: Color(0xFF96F1BA),
    gamboge800: Color(0xFF713701),
    gamboge700: Color(0xFFA96004),
    cobalt800: Color(0xFF021D72),
    cobalt700: Color(0xFF073BAC),
    cobalt600: Color(0xFF0A50CD),
    cobalt500: Color(0xFF0F68EF),
    cobalt300: Color(0xFF6DB0FA),
    cobalt200: Color(0xFFCEE9FE),
    crimson800: Color(0xFF7A0A31),
    crimson700: Color(0xFFB71C37),
    crimson600: Color(0xFFDB2838),
    crimson400: Color(0xFFFF7669),
    deepLemon800: Color(0xFF795705),
    deepLemon700: Color(0xFFB68B0D),
    deepLemon600: Color(0xFFD9AC13),
    deepLemon500: Color(0xFFFDCE1B),
    deepLemon550: Color(0xFFFDCF1A),
    deepLemon300: Color(0xFFFEE776),
    mint800: Color(0xFF013F4E),
    mint700: Color(0xFF047475),
    mint600: Color(0xFF058C80),
    mint500: Color(0xFF08A387),
    mint400: Color(0xFF39C7A0),
    mint300: Color(0xFF61E3B3),
    mint200: Color(0xFFCAFADF),
    royalNavy100: Color(0xFFeaf7ff),
    royalNavy300: Color(0xFF60b8f1),
    royalNavy400: Color(0xFF3997e4),
    royalNavy500: Color(0xFF003972),
    royalNavy600: Color(0xFF0052b5),
    royalNavy700: Color(0xFF003d97),
    royalNavy900: Color(0xFF001e65),
    surface: Color(0xFFF5F8FA),
  );

  static AppColors of(BuildContext context) {
    final appColor = Theme.of(context).appColor;

    current = appColor;

    return current;
  }

  AppColors copyWith({
    Color? primaryColor,
    Color? cursorColor,
    Color? persianBlue600,
    Color? persianBlue200,
    Color? persianBlue700,
    Color? neutral100,
    Color? black,
    Color? text100,
    Color? text200,
    Color? text300,
    Color? neutral500,
    Color? neutral200,
    Color? neutral800,
    Color? neutral900,
    Color? purple,
    Color? white100,
    Color? redRidingHood,
    Color? persianBlue500,
    Color? bluePastel,
    Color? grey,
    Color? green,
    Color? gamboge400,
    Color? eucalyptus600,
    Color? eucalyptus200,
    Color? deadPixel,
    Color? crimson200,
    Color? crimson500,
    Color? brilliantWhite50,
    Color? christmasSilver,
    Color? neutral700,
    Color? neutral400,
    Color? crimson300,
    Color? persianBlue300,
    Color? persianBlue400,
    Color? persianBlue800,
    Color? deepLemon200,
    Color? gamboge200,
    Color? deepLemon400,
    Color? gamboge300,
    Color? gamboge500,
    Color? gamboge600,
    Color? eucalyptus700,
    Color? neutral300,
    Color? neutral600,
    Color? black50,
    Color? graphiteBlack,
    Color? darkSpell,
    Color? cobalt400,
    Color? eucalyptus800,
    Color? eucalyptus500,
    Color? eucalyptus400,
    Color? eucalyptus300,
    Color? gamboge800,
    Color? gamboge700,
    Color? cobalt800,
    Color? cobalt700,
    Color? cobalt600,
    Color? cobalt500,
    Color? cobalt300,
    Color? cobalt200,
    Color? crimson800,
    Color? crimson700,
    Color? crimson600,
    Color? crimson400,
    Color? deepLemon800,
    Color? deepLemon700,
    Color? deepLemon600,
    Color? deepLemon500,
    Color? deepLemon550,
    Color? deepLemon300,
    Color? mint800,
    Color? mint700,
    Color? mint600,
    Color? mint500,
    Color? mint550,
    Color? mint400,
    Color? mint300,
    Color? mint200,
    Color? royalNavy100,
    Color? royalNavy300,
    Color? royalNavy400,
    Color? royalNavy500,
    Color? royalNavy600,
    Color? royalNavy700,
    Color? royalNavy900,
    Color? surface,
  }) {
    return AppColors(
      primaryColor: primaryColor ?? this.primaryColor,
      cursorColor: cursorColor ?? this.cursorColor,
      royalNavy500: royalNavy500 ?? this.royalNavy500,
      persianBlue600: persianBlue600 ?? this.persianBlue600,
      persianBlue200: persianBlue200 ?? this.persianBlue200,
      neutral100: neutral100 ?? this.neutral100,
      black: black ?? this.black,
      text100: text100 ?? this.text100,
      text200: text200 ?? this.text200,
      text300: text300 ?? this.text300,
      neutral500: neutral500 ?? this.neutral500,
      neutral200: neutral200 ?? this.neutral200,
      neutral800: neutral800 ?? this.neutral800,
      neutral900: neutral900 ?? this.neutral900,
      purple: purple ?? this.purple,
      white100: white100 ?? this.white100,
      redRidingHood: redRidingHood ?? this.redRidingHood,
      persianBlue500: persianBlue500 ?? this.persianBlue500,
      bluePastel: bluePastel ?? this.bluePastel,
      grey: grey ?? this.grey,
      green: green ?? this.green,
      gamboge400: gamboge400 ?? this.gamboge400,
      eucalyptus600: eucalyptus600 ?? this.eucalyptus600,
      eucalyptus200: eucalyptus200 ?? this.eucalyptus200,
      deadPixel: deadPixel ?? this.deadPixel,
      crimson200: crimson200 ?? this.crimson200,
      crimson500: crimson500 ?? this.crimson500,
      neutral700: neutral700 ?? this.neutral700,
      neutral400: neutral400 ?? this.neutral400,
      crimson300: crimson300 ?? this.crimson300,
      brilliantWhite50: brilliantWhite50 ?? this.brilliantWhite50,
      neutral600: neutral600 ?? this.neutral600,
      persianBlue300: persianBlue300 ?? this.persianBlue300,
      darkSpell: darkSpell ?? this.darkSpell,
      graphiteBlack: graphiteBlack ?? this.graphiteBlack,
      black50: black50 ?? this.black50,
      neutral300: neutral300 ?? this.neutral300,
      eucalyptus700: eucalyptus700 ?? this.eucalyptus700,
      gamboge600: gamboge600 ?? this.gamboge600,
      gamboge500: gamboge500 ?? this.gamboge500,
      gamboge300: gamboge300 ?? this.gamboge300,
      deepLemon400: deepLemon400 ?? this.deepLemon400,
      gamboge200: gamboge200 ?? this.gamboge200,
      deepLemon200: deepLemon200 ?? this.deepLemon200,
      persianBlue800: persianBlue800 ?? this.persianBlue800,
      persianBlue400: persianBlue400 ?? this.persianBlue400,
      cobalt400: cobalt400 ?? this.cobalt400,
      persianBlue700: persianBlue700 ?? this.persianBlue700,
      eucalyptus800: eucalyptus800 ?? this.eucalyptus800,
      eucalyptus500: eucalyptus500 ?? this.eucalyptus500,
      eucalyptus400: eucalyptus400 ?? this.eucalyptus400,
      eucalyptus300: eucalyptus300 ?? this.eucalyptus300,
      gamboge800: gamboge800 ?? this.gamboge800,
      gamboge700: gamboge700 ?? this.gamboge700,
      cobalt800: cobalt800 ?? this.cobalt800,
      cobalt700: cobalt700 ?? this.cobalt700,
      cobalt600: cobalt600 ?? this.cobalt600,
      cobalt500: cobalt500 ?? this.cobalt500,
      cobalt300: cobalt300 ?? this.cobalt300,
      cobalt200: cobalt200 ?? this.cobalt200,
      crimson800: crimson800 ?? this.crimson800,
      crimson700: crimson700 ?? this.crimson700,
      crimson600: crimson600 ?? this.crimson600,
      crimson400: crimson400 ?? this.crimson400,
      deepLemon800: deepLemon800 ?? this.deepLemon800,
      deepLemon700: deepLemon700 ?? this.deepLemon700,
      deepLemon600: deepLemon600 ?? this.deepLemon600,
      deepLemon500: deepLemon500 ?? this.deepLemon500,
      deepLemon550: deepLemon550 ?? this.deepLemon550,
      deepLemon300: deepLemon300 ?? this.deepLemon300,
      mint800: mint800 ?? this.mint800,
      mint700: mint700 ?? this.mint700,
      mint600: mint600 ?? this.mint600,
      mint500: mint500 ?? this.mint500,
      mint400: mint400 ?? this.mint400,
      mint300: mint300 ?? this.mint300,
      mint200: mint200 ?? this.mint200,
      royalNavy100: royalNavy100 ?? this.royalNavy100,
      royalNavy300: royalNavy300 ?? this.royalNavy300,
      royalNavy400: royalNavy400 ?? this.royalNavy400,
      royalNavy600: royalNavy600 ?? this.royalNavy600,
      royalNavy700: royalNavy700 ?? this.royalNavy700,
      royalNavy900: royalNavy900 ?? this.royalNavy900,
      surface: surface ?? this.surface,
    );
  }
}
