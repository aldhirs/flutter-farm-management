import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';

class ButtonText extends StatelessWidget {
  const ButtonText({
    this.text = '',
    this.onPressed,
    this.maxLines,
    this.onLongPressed,
    this.leftIcon,
    this.rightIcon,
    this.color,
    this.padding = const EdgeInsets.all(0),
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final String text;
  final int? maxLines;
  final Color? color;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      onLongPress: onLongPressed,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          leftIcon ?? const SizedBox.shrink(),
          leftIcon != null
              ? const SizedBox(width: Dimens.d8)
              : const SizedBox.shrink(),
          Text(
            text,
            maxLines: maxLines,
            overflow: maxLines != null ? TextOverflow.ellipsis : null,
            style: TextStyles.button3().copyWith(
              color: color ?? AppColors.current.primaryColor,
            ),
          ),
          rightIcon != null
              ? const SizedBox(width: Dimens.d8)
              : const SizedBox.shrink(),
          rightIcon ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
