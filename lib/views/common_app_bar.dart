import 'package:dartx/dartx.dart';
import 'package:farm/extensions/bool.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  CommonAppBar({
    super.key,
    this.leading,
    this.leadingWidth,
    this.backgroundColor,
    this.foregroundColor,
    this.automaticallyImplyLeading = true,
    this.height,
    this.title,
    this.titleText,
    this.onLeadingPressed,
    this.surfaceTintColor,
    this.elevation,
    this.shadowColor,
    this.actions,
    this.bottom,
    this.titleSpacing = 0,
    this.centeredTitle = true,
    this.forceMaterialTransparency = true,
  }) : preferredSize = Size.fromHeight(height ?? Dimens.d56);

  final bool automaticallyImplyLeading;
  final Widget? leading;
  final bool? centeredTitle;
  final bool? forceMaterialTransparency;
  final String? titleText;
  final Widget? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? surfaceTintColor;
  final Color? shadowColor;
  final double? leadingWidth;
  final double? height;
  final double? elevation;
  final double? titleSpacing;
  final dynamic? bottom;
  final VoidCallback? onLeadingPressed;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centeredTitle,
      titleSpacing: titleSpacing,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leadingWidth: leadingWidth,
      title: titleText?.isNotEmpty == true ? _title() : title,
      foregroundColor: foregroundColor,
      surfaceTintColor: surfaceTintColor,
      scrolledUnderElevation: 0.0,
      forceMaterialTransparency: forceMaterialTransparency.defaultTrue(),
      flexibleSpace: backgroundColor == null
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF25AFCB), AppColors.current.mint500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            )
          : null,
      backgroundColor:
          backgroundColor ?? Colors.transparent, // biar gradient yang tampil
      elevation: elevation,
      shadowColor: shadowColor,
      leading:
          leading ?? (automaticallyImplyLeading ? _leading(context) : null),
      actions: actions,
      bottom: bottom,
    );
  }

  Widget _title() {
    if (titleText.orEmpty().isEmpty) {
      return const SizedBox.shrink();
    }
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        titleText.orEmpty(),
        style: TextStyles.heading6().copyWith(color: Colors.white),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        maxLines: 1,
      ),
    );
  }

  Widget _leading(BuildContext context) {
    return IconButton(
      icon: Assets.icons.icArrowLeft.svg(
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
      onPressed: onLeadingPressed ?? () => context.read<AppNavigator>().pop(),
    );
  }
}
