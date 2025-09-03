import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';

class CheckboxButton extends StatelessWidget {
  const CheckboxButton({
    super.key,
    required this.value,
    this.onChanged,
    this.isEnabled = true,
  });

  final bool value;
  final Function(bool?)? onChanged;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEnabled,
      child: Checkbox(
        value: value,
        onChanged: onChanged,
        fillColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (!isEnabled) {
            return AppColors.current.neutral300; // warna disable
          }
          return value ? AppColors.current.mint700 : Colors.white;
        }),
        side: BorderSide(
          width: Dimens.d1,
          color: isEnabled
              ? AppColors.current.neutral700
              : AppColors.current.neutral300,
        ),
      ),
    );
  }
}
