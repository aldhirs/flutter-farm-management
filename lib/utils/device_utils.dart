import 'package:farm/constants/enum_constants.dart';
import 'package:farm/constants/ui/device_constants.dart';
import 'package:flutter/material.dart';

class DeviceUtils {
  const DeviceUtils._();

  static DeviceType getDeviceType() {
    if (MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.first,
        ).size.shortestSide <
        DeviceConstants.maxMobileWidthForDeviceType) {
      return DeviceType.mobile;
    } else {
      return DeviceType.tabletLandscape;
    }
  }

  static bool isTabletFixFullWidth() {
    return MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.first,
        ).size.width >=
        DeviceConstants.maxTabletFixWidth;
  }

  static double? getTabletFixFullWidth() {
    return DeviceUtils.isTabletFixFullWidth()
        ? DeviceConstants.maxTabletFixWidth.toDouble()
        : null;
  }

  static DeviceType getDeviceTypeOf(BuildContext context) {
    if (MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.first,
        ).size.shortestSide <
        DeviceConstants.maxMobileWidthForDeviceType) {
      return DeviceType.mobile;
    } else {
      return MediaQuery.of(context).orientation == Orientation.portrait
          ? DeviceType.tabletPortrait
          : DeviceType.tabletLandscape;
    }
  }
}
