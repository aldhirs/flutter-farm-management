import 'package:dartx/dartx.dart';
import 'package:farm/extensions/string.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/device_utils.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/views/view.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/buttons/button_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.description,
    this.buttonText,
    this.buttonSize,
    this.secondaryButtonText,
    this.onPressed,
    this.onSecondaryPressed,
    this.tabletPortraitWidth = 0.4,
    this.tabletLandscapeWidth = 0.3,
    this.imageAssets,
    this.isButtonFullWidth = true,
    this.isEnabledPositifButton = true,
    this.colorTitle,
    this.leftIconButton,
  });

  final dynamic imageAssets;
  final String? title;
  final dynamic description;
  final String? buttonText;
  final String? secondaryButtonText;
  final num tabletPortraitWidth;
  final num tabletLandscapeWidth;
  final bool isButtonFullWidth;
  final bool isEnabledPositifButton;
  final Color? colorTitle;
  final Widget? leftIconButton;
  final ButtonSize? buttonSize;

  final void Function()? onPressed;
  final void Function()? onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobile: _emptyState(ViewUtils.screenWidth(), false),
      tabletPotrait: _emptyState(
        ViewUtils.screenWidth() * tabletPortraitWidth,
        true,
      ),
      tabletLandscape: _emptyState(
        ViewUtils.screenWidth() * tabletLandscapeWidth,
        true,
      ),
    );
  }

  Widget _emptyState(double width, bool isTablet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.d16),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: !isTablet ? MainAxisSize.min : MainAxisSize.max,
        children: [
          SizedBox(height: isTablet ? Dimens.d64 : 0),
          SizedBox(
            width: DeviceUtils.getDeviceType() == DeviceType.mobile
                ? width * 0.7
                : width,
            child: imageAssets,
          ),
          Visibility(
            visible: title?.isNotEmpty == true,
            child: Container(
              width: width,
              padding: const EdgeInsets.only(top: Dimens.d16),
              child: Text(
                title.orEmpty(),
                textAlign: TextAlign.center,
                style: TextStyles.heading4().copyWith(
                  color: colorTitle ?? AppColors.current.mint800,
                ),
              ),
            ),
          ),
          Visibility(
            visible: description != null,
            child: const SizedBox(height: Dimens.d8),
          ),
          Visibility(
            visible: description != null,
            child: SizedBox(
              width: width,
              child: description is String
                  ? Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyles.paragraph1(),
                    )
                  : description,
            ),
          ),
          Visibility(
            visible: buttonText?.isNotEmpty == true,
            child: Column(
              children: [
                const SizedBox(height: Dimens.d16),
                Center(
                  child: Button(
                    size: buttonSize ?? ButtonSize.medium,
                    fulLWidth: isButtonFullWidth,
                    type: isEnabledPositifButton
                        ? ButtonType.primary
                        : ButtonType.disabled,
                    text: buttonText.defaultValue('Try Again'),
                    onPressed: onPressed,
                    leftIcon: leftIconButton,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible:
                secondaryButtonText?.isNotEmpty == true ||
                onSecondaryPressed != null,
            child: Column(
              children: [
                const SizedBox(height: Dimens.d8),
                ButtonText(
                  text: secondaryButtonText.defaultValue('Try Again'),
                  onPressed: onSecondaryPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
