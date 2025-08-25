import 'package:farm/constants/ui/device_constants.dart';
import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    required this.mobile,
    this.tabletPotrait,
    this.tabletLandscape,
    super.key,
  });

  final Widget mobile;
  final Widget? tabletPotrait;
  final Widget? tabletLandscape;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= DeviceConstants.maxMobileWidth) {
          return mobile;
        } else if (constraints.maxWidth >= DeviceConstants.maxTabletWidth) {
          return tabletLandscape ?? mobile;
        } else {
          return tabletPotrait ?? mobile;
        }
      },
    );
  }
}
