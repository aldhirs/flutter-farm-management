import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';

class CheckboxInput extends StatelessWidget {
  const CheckboxInput({
    super.key,
    required this.value,
    this.text = "",
    this.onChanged,
    this.isError = false,
  });

  final String text;
  final bool isError;
  final bool value;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: -8,
      children: [
        Checkbox(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
          side: WidgetStateBorderSide.resolveWith(
            (states) =>
                BorderSide(width: 1.5, color: AppColors.current.neutral500),
          ),
          activeColor: AppColors.current.primaryColor,
          value: value,
          isError: isError,
          onChanged: onChanged,
        ),
        Text(text, style: TextStyles.label6()),
      ],
    );
  }
}
