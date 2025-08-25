import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    required this.type,
    this.size = ButtonSize.medium,
    this.text = '',
    this.onPressed,
    this.onLongPressed,
    this.leftIcon,
    this.rightIcon,
    this.padding = const EdgeInsets.all(0),
    this.fulLWidth = false,
    this.loading = false,
    this.minWidth = Dimens.d100,
    super.key,
  });

  final String text;
  final ButtonType type;
  final ButtonSize size;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final bool fulLWidth;
  final bool loading;
  final double minWidth;
  final EdgeInsetsGeometry padding;

  List<ButtonType> disabledTypeList() {
    return [
      ButtonType.disabled,
      ButtonType.disabledDanger,
      ButtonType.disabledGhost,
    ];
  }

  VoidCallback? onTapEnableState() =>
      !disabledTypeList().contains(type) ? onPressed : null;

  VoidCallback? onLongTapEnableState() =>
      !disabledTypeList().contains(type) ? onLongPressed : null;

  BorderRadius circular() => BorderRadius.circular(Dimens.d32);

  Container button() {
    return Container(
      constraints: BoxConstraints(minWidth: minWidth, minHeight: size.size),
      child: Ink(
        decoration: BoxDecoration(
          color: type.backgroundColor,
          borderRadius: circular(),
          border: Border.all(width: Dimens.d1, color: type.borderColor),
        ),
        padding: EdgeInsets.only(
          left: Dimens.d16,
          right: Dimens.d16,
          top: size.padding,
          bottom: size.padding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leftIcon ?? const SizedBox(),
            const SizedBox(width: Dimens.d4),
            _loading(),
            Text(text, style: textStyle().copyWith(color: type.textColor)),
            const SizedBox(width: Dimens.d4),
            rightIcon ?? const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _loading() {
    return loading
        ? Container(
            width: Dimens.d12,
            height: Dimens.d12,
            margin: const EdgeInsets.only(right: Dimens.d8),
            child: CircularProgressIndicator(
              color: type.textColor,
              strokeWidth: 2,
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: padding,
        child: InkWell(
          onTap: onTapEnableState(),
          onDoubleTap: onLongTapEnableState(),
          customBorder: RoundedRectangleBorder(borderRadius: circular()),
          child: fulLWidth
              ? button()
              : Wrap(direction: Axis.vertical, children: [button()]),
        ),
      ),
    );
  }

  TextStyle textStyle() {
    switch (size) {
      case ButtonSize.extraLarge:
      case ButtonSize.large:
        return TextStyles.button1();
      case ButtonSize.medium:
        return TextStyles.button2();
      case ButtonSize.small:
        return TextStyles.button3();
    }
  }
}
