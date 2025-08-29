import 'package:dartx/dartx.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button_text.dart';
import 'package:flutter/material.dart';

class TickerView extends StatelessWidget {
  const TickerView({
    super.key,
    required this.type,
    this.message = "",
    this.actionText,
    this.onActionPressed,
    this.isError = false,
  });

  final TickerViewType type;
  final String message;
  final String? actionText;
  final bool isError;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimen.current.screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.d10),
        color: type.backgroundColor,
      ),
      padding: EdgeInsets.only(
        right: actionText?.isNotEmpty == true ? Dimens.d8 : Dimens.d16,
      ),
      child: Align(
        alignment: Alignment.center,
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsetsGeometry.only(left: 16, right: 8),
                child: Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(Dimens.d10),
                    ),
                    child: type.icon,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: Dimens.d16,
                    bottom: Dimens.d16,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      message,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: TextStyles.paragraph2(),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: actionText?.isNotEmpty == true,
                child: Expanded(
                  child: ButtonText(
                    onPressed: onActionPressed,
                    maxLines: 1,
                    text: actionText.orEmpty(),
                    color: type.actionTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
