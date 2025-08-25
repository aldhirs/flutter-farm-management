import 'package:dartx/dartx.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedDefaultLoading extends StatelessWidget {
  const AnimatedDefaultLoading({
    super.key,
    this.loadingType = AnimatedLoadingType.pen_rotate,
  });

  final AnimatedLoadingType? loadingType;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.d10),
        ),
        child: Wrap(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: Dimens.d16,
                vertical: Dimens.d26,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    (loadingType?.value).orEmpty(),
                    height: Dimens.d64,
                  ),
                  Text("Progress", style: TextStyles.paragraph3()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
