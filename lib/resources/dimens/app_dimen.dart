import 'package:farm/constants/enum_constants.dart';
import 'package:farm/constants/ui/device_constants.dart';
import 'package:farm/utils/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as u;

class AppDimen {
  AppDimen._({
    required this.screenWidth,
    required this.screenHeight,
    required this.devicePixelRatio,
    required this.deviceType,
  });

  static late AppDimen current;

  final double screenWidth;
  final double screenHeight;
  final double devicePixelRatio;
  final DeviceType deviceType;

  static AppDimen of(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    final screen = AppDimen._(
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      devicePixelRatio: devicePixelRatio,
      deviceType: DeviceUtils.getDeviceTypeOf(context),
    );

    current = screen;

    return current;
  }

  double responsiveDimens({
    required double mobile,
    double? tabletPortrait,
    double? tabletLandscape,
  }) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile.w;
      case DeviceType.tabletPortrait:
        return tabletPortrait?.w ??
            ((mobile * DeviceConstants.maxMobileWidth) /
                DeviceConstants.designDeviceWidth);
      case DeviceType.tabletLandscape:
        return tabletLandscape?.w ??
            ((mobile * DeviceConstants.maxMobileWidth) /
                DeviceConstants.designDeviceWidth);
    }
  }

  TextStyle responsiveTextStyle(
    TextStyle mobile,
    TextStyle? tablet,
    TextStyle? desktop,
  ) {
    if (screenWidth <= DeviceConstants.maxMobileWidthTextStyle) {
      return mobile;
    } else if (screenWidth > DeviceConstants.minTabletWidthTextStyle &&
        screenWidth <= DeviceConstants.maxTabletWidthTextStyle) {
      return tablet ?? mobile;
    } else if (screenWidth >= DeviceConstants.minDesktopWidthTextStyle) {
      return desktop ?? mobile;
    }
    return mobile;
  }
}

extension ResponsiveDoubleExtension on double {
  double responsive({double? tabletPortrait, double? tabletLandscape}) {
    return AppDimen.current.responsiveDimens(
      mobile: this,
      tabletPortrait: tabletPortrait,
      tabletLandscape: tabletLandscape,
    );
  }
}
