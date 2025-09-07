import 'package:dartx/dartx.dart';
import 'package:farm/extensions/bool.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/views/responsive_widget.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/inputs/text_input_field.dart';
import 'package:flutter/material.dart';

/// Refer to PopupFactory in the Android Design System
/// Support responsive design tablet portrait, landscape and mobile
class Popup extends StatelessWidget {
  const Popup({
    this.title = '',
    this.description,
    this.content,
    this.customPositiveButton,
    this.textInputTitle,
    this.textInputHint,
    this.textFieldVisibility,
    this.onPositiveButtonPressed,
    this.onNegativeButtonPressed,
    this.onClosePressed,
    this.positiveButtonText,
    this.negativeButtonText,
    this.positiveButtonType = ButtonType.primary,
    this.closeVisibility,
    this.illustration,
    this.isLoading,
    this.onChanged,
    this.tabletPortraitWidth = 0.35,
    this.tabletLandscapeWidth = 0.25,
    super.key,
  });

  final void Function(String)? onChanged;
  final void Function()? onPositiveButtonPressed;
  final void Function()? onNegativeButtonPressed;
  final void Function()? onClosePressed;
  final String? title;
  final List<InlineSpan>? description;
  final Widget? content;
  final Widget? customPositiveButton;
  final String? textInputTitle;
  final num tabletPortraitWidth;
  final num tabletLandscapeWidth;
  final String? textInputHint;
  final bool? textFieldVisibility;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final ButtonType? positiveButtonType;
  final bool? closeVisibility;
  final Widget? illustration;
  final bool? isLoading;

  void _onClosePressed(BuildContext context) {
    Navigator.pop(context);
    onClosePressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(Dimens.d20),
      backgroundColor: AppColors.current.neutral100,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.d10),
      ),
      child: ResponsiveWidget(
        mobile: _popupWidget(context),
        tabletPotrait: SizedBox(
          width: ViewUtils.screenWidth() * tabletPortraitWidth,
          child: _popupWidget(context),
        ),
        tabletLandscape: SizedBox(
          width: ViewUtils.screenWidth() * tabletLandscapeWidth,
          child: _popupWidget(context),
        ),
      ),
    );
  }

  Widget _popupWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimens.d24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          content == null
              ? _popUpHeaderWidget(context)
              : const SizedBox.shrink(),
          content ?? const SizedBox(),
          Visibility(
            visible: content == null,
            child: const SizedBox(height: Dimens.d8),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyles.paragraph2(),
              children: description,
            ),
          ),
          Visibility(
            visible: content == null,
            child: const SizedBox(height: Dimens.d16),
          ),
          Visibility(
            visible: textFieldVisibility ?? false,
            child: Container(
              margin: const EdgeInsets.only(bottom: Dimens.d16),
              child: TextInputField(
                onChanged: onChanged,
                label: textInputTitle.orEmpty(),
                hintText: textInputHint.orEmpty(),
              ),
            ),
          ),
          Visibility(
            visible: textFieldVisibility.defaultFalse(),
            child: Divider(
              thickness: Dimens.d1,
              color: AppColors.current.neutral500,
            ),
          ),
          SizedBox(height: textFieldVisibility.defaultFalse() ? Dimens.d16 : 0),
          Visibility(
            visible: positiveButtonText?.isNotEmpty == true,
            child: Stack(
              children: [
                customPositiveButton != null
                    ? customPositiveButton!
                    : Button(
                        fulLWidth: true,
                        type: positiveButtonType ?? ButtonType.primary,
                        text: positiveButtonText.orEmpty(),
                        onPressed: onPositiveButtonPressed,
                        loading: isLoading.defaultFalse(),
                      ),
              ],
            ),
          ),
          Visibility(
            visible: content == null,
            child: const SizedBox(height: Dimens.d8),
          ),
          Visibility(
            visible: negativeButtonText?.isNotEmpty == true,
            child: Button(
              type: ButtonType.ghost,
              text: negativeButtonText.orEmpty(),
              onPressed: onNegativeButtonPressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _popUpHeaderWidget(BuildContext context) {
    if (textFieldVisibility.defaultFalse()) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: SizedBox()),
              Text(
                title.orEmpty(),
                textAlign: TextAlign.center,
                style: TextStyles.body1().copyWith(
                  color: AppColors.current.mint800,
                ),
              ),
              Expanded(
                child: Visibility(
                  visible: closeVisibility.defaultFalse(),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => _onClosePressed(context),
                      child: Icon(
                        Icons.close,
                        size: Dimens.d24,
                        color: AppColors.current.neutral900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.d16),
          Visibility(
            visible: textFieldVisibility.defaultFalse(),
            child: Divider(
              thickness: Dimens.d1,
              color: AppColors.current.neutral500,
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Visibility(
            visible: closeVisibility.defaultFalse(),
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => _onClosePressed(context),
                child: Icon(
                  Icons.close,
                  size: Dimens.d24,
                  color: AppColors.current.neutral900,
                ),
              ),
            ),
          ),
          const SizedBox(height: Dimens.d16),
          illustration ?? Container(),
          SizedBox(height: illustration != null ? Dimens.d16 : 0),
          Text(
            title.orEmpty(),
            textAlign: TextAlign.center,
            style: TextStyles.body1().copyWith(
              color: AppColors.current.mint800,
            ),
          ),
        ],
      );
    }
  }
}
