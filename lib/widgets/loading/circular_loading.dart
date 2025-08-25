import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {
  const CircularLoading({
    super.key,
    this.color,
    this.strokeWidth = 2,
    this.size = CircularLoadingSize.medium,
    this.value,
  });

  final Color? color;
  final CircularLoadingSize size;
  final double strokeWidth;
  final double? value;

  @override
  Widget build(BuildContext context) {
    final finalColor = color ?? AppColors.current.royalNavy500;
    return SizedBox(
      width: size.size,
      height: size.size,
      child: CircularProgressIndicator(
        color: finalColor,
        strokeWidth: strokeWidth,
        value: value,
      ),
    );
  }
}
