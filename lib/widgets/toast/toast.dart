import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  late FToast _fToast;

  void init(BuildContext context) {
    _fToast = FToast();
    _fToast.init(context);
  }

  void showToast({
    required BuildContext context,
    required String message,
    required ToastType type,
    String actionText = '',
    bool showCloseIcon = false,
    bool showAction = false,
  }) {
    _fToast = FToast();
    _fToast.init(context);
    _fToast.showToast(
      child: _buildToastWidget(
        message,
        type,
        actionText,
        showCloseIcon,
        showAction,
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: Dimens.d2.toInt()),
    );
  }

  Widget _buildToastWidget(
    String message,
    ToastType type,
    String actionText,
    bool showCloseIcon,
    bool showAction,
  ) {
    return CustomToastWidget(
      message: message,
      actionText: actionText,
      type: type,
      showAction: showAction,
      showCloseIcon: showCloseIcon,
    );
  }
}

class CustomToastWidget extends StatelessWidget {
  final String message;
  final String actionText;
  final ToastType type;
  final bool showCloseIcon;
  final bool showAction;
  final VoidCallback? onActionTap;
  final VoidCallback? onClose;

  const CustomToastWidget({
    super.key,
    required this.message,
    this.actionText = '',
    this.type = ToastType.info,
    this.showAction = false,
    this.showCloseIcon = false,
    this.onActionTap,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.d16,
        vertical: Dimens.d10,
      ),
      decoration: BoxDecoration(
        color: type.backgroundColor,
        borderRadius: BorderRadius.circular(Dimens.d10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(Dimens.d25.toInt()),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SvgGenImage(type.icon).svg(width: Dimens.d24, height: Dimens.d24),
          const SizedBox(width: Dimens.d8),
          Expanded(
            child: RichText(
              text: TextSpan(text: message, style: TextStyles.paragraph3()),
            ),
          ),
          const SizedBox(width: Dimens.d8),
          Visibility(
            visible: showAction,
            child: GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText,
                style: TextStyles.button3().copyWith(
                  color: type.textActionColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: Dimens.d8),
          Visibility(
            visible: showCloseIcon,
            child: GestureDetector(
              onTap: onClose,
              child: const Icon(
                Icons.close,
                color: Colors.black,
                size: Dimens.d24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum ToastType {
  succes(
    icon: 'assets/icons/ic_toast_success.svg',
    textActionColor: Color(0xFF279780),
    backgroundColor: Color(0xFFDCFCE3),
  ),
  info(
    icon: 'assets/icons/ic_toast_info.svg',
    textActionColor: Color(0xFF003972),
    backgroundColor: Color(0xFFEAF7FF),
  ),
  warning(
    icon: 'assets/icons/ic_toast_warning.svg',
    textActionColor: Color(0xFFA96004),
    backgroundColor: Color(0xFFFEF9D1),
  ),
  error(
    icon: 'assets/icons/ic_toast_error.svg',
    textActionColor: Color(0xFFFF3838),
    backgroundColor: Color(0xFFFFE4D7),
  );

  final String icon;
  final Color backgroundColor;
  final Color textActionColor;
  const ToastType({
    required this.icon,
    required this.textActionColor,
    required this.backgroundColor,
  });
}
