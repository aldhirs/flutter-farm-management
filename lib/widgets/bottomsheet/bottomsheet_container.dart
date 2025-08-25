import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';

class BottomsheetContainer extends StatelessWidget {
  const BottomsheetContainer({
    super.key,
    required this.content,
    this.isPlain = false,
  });

  final Widget content;
  final bool isPlain;

  @override
  Widget build(BuildContext context) {
    return isPlain
        ? Wrap(children: [content])
        : SizedBox(
            width: double.infinity,
            child: Wrap(
              children: [
                Align(
                  child: Container(
                    width: Dimens.d64,
                    height: Dimens.d4,
                    margin: const EdgeInsets.only(
                      top: Dimens.d16,
                      bottom: Dimens.d8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.current.neutral500,
                      borderRadius: BorderRadius.circular(Dimens.d10),
                    ),
                  ),
                ),
                content,
              ],
            ),
          );
  }
}
