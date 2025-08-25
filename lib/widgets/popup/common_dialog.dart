import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/widgets/popup/popup_button.dart';
import 'package:farm/widgets/popup/popup_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// basic dialog based on platform android or ios
class CommonDialog extends StatelessWidget {
  const CommonDialog({
    this.commonPopupType = PopupType.adaptive,
    this.actions = const <PopupButton>[],
    this.title,
    this.message,
    super.key,
  });

  const CommonDialog.android({
    List<PopupButton> actions = const <PopupButton>[],
    String? title,
    String? message,
    Key? key,
  }) : this(
         commonPopupType: PopupType.android,
         actions: actions,
         title: title,
         message: message,
         key: key,
       );

  const CommonDialog.ios({
    List<PopupButton> actions = const <PopupButton>[],
    String? title,
    String? message,
    Key? key,
  }) : this(
         commonPopupType: PopupType.ios,
         actions: actions,
         title: title,
         message: message,
         key: key,
       );

  const CommonDialog.adaptive({
    List<PopupButton> actions = const <PopupButton>[],
    String? title,
    String? message,
    Key? key,
  }) : this(
         commonPopupType: PopupType.adaptive,
         actions: actions,
         title: title,
         message: message,
         key: key,
       );

  final PopupType commonPopupType;
  final List<PopupButton> actions;
  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    switch (commonPopupType) {
      case PopupType.android:
        return _buildAndroidDialog();
      case PopupType.ios:
        return _buildIosDialog();
      case PopupType.adaptive:
        return Platform.isIOS ? _buildIosDialog() : _buildAndroidDialog();
    }
  }

  Widget _buildAndroidDialog() {
    return AlertDialog(
      actions: actions
          .map(
            (e) => TextButton(
              onPressed: e.onPressed?.function,
              child: Text(e.text ?? 'Ok', style: TextStyles.heading6()),
            ),
          )
          .toList(growable: false),
      title: title != null ? Text(title.orEmpty()) : null,
      content: message != null ? Text(message.orEmpty()) : null,
    );
  }

  Widget _buildIosDialog() {
    return CupertinoAlertDialog(
      actions: actions
          .map(
            (e) => CupertinoDialogAction(
              onPressed: e.onPressed?.function,
              child: Text(e.text ?? 'Ok'),
            ),
          )
          .toList(growable: false),
      title: title != null ? Text(title.orEmpty()) : null,
      content: message != null ? Text(message.orEmpty()) : null,
    );
  }
}
