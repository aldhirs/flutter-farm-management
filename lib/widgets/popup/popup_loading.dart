import 'package:farm/resources/resource.dart';
import 'package:farm/utils/view_utils.dart';
import 'package:farm/views/responsive_widget.dart';
import 'package:farm/widgets/loading/circular_loading.dart';
import 'package:flutter/material.dart';

class PopupLoading extends StatelessWidget {
  const PopupLoading({
    this.tabletPortraitWidth = 0.7,
    this.tabletLandscapeWidth = 0.4,
    super.key,
    this.description = "",
  });

  final String description;
  final num tabletPortraitWidth;
  final num tabletLandscapeWidth;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimens.d28),
      backgroundColor: AppColors.current.neutral100,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.d10),
      ),
      child: ResponsiveWidget(
        mobile: _contentWidget(context),
        tabletPotrait: SizedBox(
          width: ViewUtils.screenWidth() * tabletPortraitWidth,
          child: _contentWidget(context),
        ),
        tabletLandscape: SizedBox(
          width: ViewUtils.screenWidth() * tabletLandscapeWidth,
          child: _contentWidget(context),
        ),
      ),
    );
  }

  Widget _contentWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.d16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularLoading(),
          const SizedBox(height: Dimens.d16),
          Text(description, style: TextStyles.body3()),
        ],
      ),
    );
  }
}
