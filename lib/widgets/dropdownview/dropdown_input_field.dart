import 'package:farm/extensions/bool.dart';
import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class DropdownInputField extends StatefulWidget {
  DropdownInputField({
    super.key,
    this.textFormFieldKey,
    this.label = '',
    this.initialValue,
    this.hintText = '',
    this.prefixIcon,
    this.customSuffixIcon,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.obscureText = false,
    this.enableToggleObscure = false,
    this.dropdownInputState,
    this.maxLength,
    this.maxLines = 1,
    this.errorText = '',
    this.enableInteractiveSelection = false,
    this.inputFormatter,
    this.onTap,
    this.successTextInfo,
    this.additionalInfo,
    this.enabled,
    this.isShowDropdown = false,
  });

  final Key? textFormFieldKey;
  final String label;
  final String hintText;
  final String errorText;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? customSuffixIcon;
  bool? isShowDropdown;
  final void Function(String)? onChanged;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  bool obscureText;
  final bool enableToggleObscure;
  DropdownInputState? dropdownInputState;
  final int? maxLength;
  final int? maxLines;
  final bool? enableInteractiveSelection;
  final List<TextInputFormatter>? inputFormatter;
  final void Function()? onTap;
  final String? successTextInfo;
  final String? additionalInfo;
  final bool? enabled;

  @override
  State<DropdownInputField> createState() => _DropdownInputFieldState();
}

class _DropdownInputFieldState extends State<DropdownInputField> {
  final _borderRadius = BorderRadius.circular(Dimens.d8);
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.dropdownInputState = DropdownInputState.inactive;
    _focusNode.addListener(() {
      setState(() {
        if (_focusNode.hasFocus) {
          widget.dropdownInputState = DropdownInputState.active;
          widget.isShowDropdown = true;
        } else {
          widget.dropdownInputState = DropdownInputState.inactive;
          widget.isShowDropdown = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          readOnly: true,
          showCursor: false,
          onTap: widget.onTap,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          focusNode: _focusNode,
          obscureText: widget.obscureText,
          obscuringCharacter: '●',
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          enableInteractiveSelection: true,
          controller: widget.controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: widget.keyboardType,
          initialValue: widget.initialValue,
          enabled: widget.enabled.defaultTrue(),
          buildCounter:
              (
                context, {
                required currentLength,
                required isFocused,
                required maxLength,
              }) => widget.maxLength != null
              ? Transform.translate(
                  offset: const Offset(10, -6),
                  child: Text(
                    '$currentLength/$maxLength',
                    style: TextStyles.label3().copyWith(
                      color: widget.dropdownInputState?.hintColor,
                    ),
                  ),
                )
              : null,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelStyle: TextStyles.label1().copyWith(
              color: (widget.isShowDropdown.defaultFalse()
                  ? AppColors.current.mint700
                  : AppColors.current.text300),
            ),
            labelText: widget.label,
            hintText: _focusNode.hasFocus ? '' : widget.hintText,
            hintStyle: TextStyles.label1().copyWith(
              color: widget.dropdownInputState?.hintColor,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: _dropdownIcon(),
            error: _errorText(),
            enabledBorder: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(
                width: 2,
                color: (widget.isShowDropdown.defaultFalse()
                    ? AppColors.current.mint700
                    : AppColors.current.neutral700),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(
                color: (widget.isShowDropdown.defaultFalse()
                    ? AppColors.current.mint700
                    : AppColors.current.neutral700),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(
                width: 2,
                color: (widget.isShowDropdown.defaultFalse()
                    ? AppColors.current.mint700
                    : AppColors.current.neutral700),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(
                width: 2,
                color: (widget.isShowDropdown.defaultFalse()
                    ? AppColors.current.mint700
                    : AppColors.current.neutral700),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(
                width: 2,
                color: (widget.isShowDropdown.defaultFalse()
                    ? AppColors.current.mint700
                    : AppColors.current.neutral700),
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(
                width: 2,
                color: AppColors.current.neutral500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 2.0),
        Visibility(
          visible:
              widget.additionalInfo != null &&
              widget.errorText.isEmpty &&
              widget.successTextInfo == null &&
              widget.dropdownInputState != DropdownInputState.error,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.current.text300,
                  size: Dimens.d14,
                ),
              ),
              const SizedBox(width: 5.0),
              Expanded(
                child: Text(
                  widget.additionalInfo ?? '',
                  style: TextStyles.label3().copyWith(
                    color: AppColors.current.text300,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible:
              widget.successTextInfo != null &&
              widget.errorText.isEmpty &&
              widget.dropdownInputState != DropdownInputState.error,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Icon(
                  Icons.check_circle_outline,
                  color: AppColors.current.eucalyptus500,
                  size: Dimens.d14,
                ),
              ),
              const SizedBox(width: 5.0),
              Expanded(
                child: Text(
                  widget.successTextInfo ?? '',
                  style: TextStyles.label3().copyWith(
                    color: AppColors.current.eucalyptus500,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible:
              widget.errorText.isNotEmpty &&
              widget.dropdownInputState == DropdownInputState.error,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.current.crimson500,
                  size: Dimens.d14,
                ),
              ),
              const SizedBox(width: 5.0),
              Expanded(
                child: Text(
                  widget.errorText,
                  style: TextStyles.label3().copyWith(
                    color: AppColors.current.crimson500,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget? _dropdownIcon() {
    return IconButton(
      onPressed: widget.onTap,
      icon: Icon(
        widget.isShowDropdown.defaultFalse()
            ? Icons.arrow_drop_up_outlined
            : Icons.arrow_drop_down_outlined,
      ),
    );
  }

  Widget? _errorText() {
    if (widget.dropdownInputState == DropdownInputState.error) {
      return const SizedBox();
    }
    return null;
  }
}

enum DropdownInputState {
  inactive,
  active,
  filled,
  error,
  disabled;

  Color get borderColor {
    switch (this) {
      case DropdownInputState.inactive:
        return AppColors.current.neutral500;
      case DropdownInputState.filled:
      case DropdownInputState.active:
        return AppColors.current.mint700;
      case DropdownInputState.error:
        return AppColors.current.crimson500;
      case DropdownInputState.disabled:
        return AppColors.current.neutral700;
    }
  }

  Color get labelColor {
    switch (this) {
      case DropdownInputState.inactive:
        return AppColors.current.text300;
      case DropdownInputState.filled:
      case DropdownInputState.active:
        return AppColors.current.mint700;
      case DropdownInputState.error:
        return AppColors.current.crimson500;
      case DropdownInputState.disabled:
        return AppColors.current.neutral700;
    }
  }

  Color get additionalInfoColor {
    switch (this) {
      case DropdownInputState.inactive:
      case DropdownInputState.filled:
      case DropdownInputState.active:
        return AppColors.current.text300;
      case DropdownInputState.error:
        return AppColors.current.crimson500;
      case DropdownInputState.disabled:
        return AppColors.current.text200;
    }
  }

  Color get hintColor {
    switch (this) {
      case DropdownInputState.inactive:
        return AppColors.current.text300;
      case DropdownInputState.filled:
      case DropdownInputState.active:
      case DropdownInputState.error:
        return AppColors.current.text100;
      case DropdownInputState.disabled:
        return AppColors.current.neutral700;
    }
  }
}
