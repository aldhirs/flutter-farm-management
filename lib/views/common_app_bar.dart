import 'package:dartx/dartx.dart';
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
    this.automaticallyImplyLeading = true,
    this.height,
    this.title,
    this.titleText,
    this.onLeadingPressed,
    this.surfaceTintColor,
    this.elevation,
    this.shadowColor,
    this.actions,
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
  final Color? surfaceTintColor;
  final Color? shadowColor;
  final double? leadingWidth;
  final double? height;
  final double? elevation;
  final double? titleSpacing;
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
      backgroundColor: backgroundColor ?? Colors.transparent,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      scrolledUnderElevation: 0.0,
      forceMaterialTransparency: forceMaterialTransparency ?? true,
      elevation: elevation,
      shadowColor: shadowColor,
      leading:
          leading ?? (automaticallyImplyLeading ? _leading(context) : null),
      actions: actions,
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
        style: TextStyles.body2(),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        maxLines: 1,
      ),
    );
  }

  Widget _leading(BuildContext context) {
    return IconButton(
      icon: Assets.icons.icArrowLeft.svg(
        colorFilter: ColorFilter.mode(
          AppColors.current.text100,
          BlendMode.srcIn,
        ),
      ),
      onPressed: onLeadingPressed ?? () => context.read<AppNavigator>().pop(),
    );
  }
}
