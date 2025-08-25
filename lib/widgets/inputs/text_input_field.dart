import 'package:farm/extensions/bool.dart';
import 'package:farm/resources/dimens/dimens.dart';
import 'package:farm/resources/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputField extends StatefulWidget {
  TextInputField({
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
    this.textInputState,
    this.maxLength,
    this.maxLines = 1,
    this.errorText = '',
    this.enableInteractiveSelection = false,
    this.inputFormatter,
    this.onTap,
    this.successTextInfo,
    this.additionalInfo,
    this.enabled,
  });

  final Key? textFormFieldKey;
  final String label;
  final String hintText;
  final String errorText;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? customSuffixIcon;
  final void Function(String)? onChanged;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  bool obscureText;
  final bool enableToggleObscure;
  TextInputState? textInputState;
  final int? maxLength;
  final int? maxLines;
  final bool? enableInteractiveSelection;
  final List<TextInputFormatter>? inputFormatter;
  final void Function()? onTap;
  final String? successTextInfo;
  final String? additionalInfo;
  final bool? enabled;

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  final _borderRadius = BorderRadius.circular(Dimens.d8);
  final _focusNode = FocusNode();
  bool _showSuffixIcon = false;

  @override
  void initState() {
    super.initState();
    widget.textInputState = TextInputState.inactive;
    widget.controller?.addListener(() {
      setState(() {
        _showSuffixIcon = widget.controller?.text.isNotEmpty == true;
      });
    });
    _focusNode.addListener(() {
      setState(() {
        if (_focusNode.hasFocus) {
          widget.textInputState = TextInputState.active;
        } else {
          widget.textInputState = TextInputState.inactive;
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
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          focusNode: _focusNode,
          obscureText: widget.obscureText,
          obscuringCharacter: '●',
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
            setState(() {
              _showSuffixIcon = value.isNotEmpty;
            });
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
                      color: widget.textInputState?.hintColor,
                    ),
                  ),
                )
              : null,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelStyle: TextStyles.label1().copyWith(
              color:
                  widget.textInputState?.labelColor ??
                  (_focusNode.hasFocus
                      ? AppColors.current.royalNavy500
                      : AppColors.current.text300),
            ),
            labelText: _focusNode.hasFocus ? widget.label : widget.hintText,
            hintText: _focusNode.hasFocus ? '' : widget.hintText,
            hintStyle: TextStyles.label1().copyWith(
              color: widget.textInputState?.hintColor,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: _suffixIcon(),
            error: _errorText(),
            enabledBorder: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(
                color:
                    widget.textInputState?.borderColor ??
                    AppColors.current.neutral500,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(
                color:
                    widget.textInputState?.borderColor ??
                    AppColors.current.neutral500,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(
                color:
                    widget.textInputState?.borderColor ??
                    AppColors.current.royalNavy500,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(
                color:
                    widget.textInputState?.borderColor ??
                    AppColors.current.crimson500,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(
                color:
                    widget.textInputState?.borderColor ??
                    AppColors.current.crimson500,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(
                color:
                    widget.textInputState?.borderColor ??
                    AppColors.current.neutral700,
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
              widget.textInputState != TextInputState.error,
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
              widget.textInputState != TextInputState.error,
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
              widget.textInputState == TextInputState.error,
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

  Widget? _suffixIcon() {
    if (widget.enableToggleObscure) {
      return IconButton(
        onPressed: () {
          setState(() {
            widget.obscureText = !widget.obscureText;
          });
        },
        icon:
            (widget.obscureText ? Assets.icons.icEyeOn : Assets.icons.icEyeOff)
                .svg(),
      );
    }
    if (_showSuffixIcon) {
      return widget.customSuffixIcon;
    }
    return null;
  }

  Widget? _errorText() {
    if (widget.textInputState == TextInputState.error) {
      return const SizedBox();
    }
    return null;
  }
}

enum TextInputState {
  inactive,
  active,
  filled,
  error,
  disabled;

  Color get borderColor {
    switch (this) {
      case TextInputState.inactive:
        return AppColors.current.neutral500;
      case TextInputState.filled:
      case TextInputState.active:
        return AppColors.current.royalNavy500;
      case TextInputState.error:
        return AppColors.current.crimson500;
      case TextInputState.disabled:
        return AppColors.current.neutral700;
    }
  }

  Color get labelColor {
    switch (this) {
      case TextInputState.inactive:
        return AppColors.current.text300;
      case TextInputState.filled:
      case TextInputState.active:
        return AppColors.current.royalNavy500;
      case TextInputState.error:
        return AppColors.current.crimson500;
      case TextInputState.disabled:
        return AppColors.current.neutral700;
    }
  }

  Color get additionalInfoColor {
    switch (this) {
      case TextInputState.inactive:
      case TextInputState.filled:
      case TextInputState.active:
        return AppColors.current.text300;
      case TextInputState.error:
        return AppColors.current.crimson500;
      case TextInputState.disabled:
        return AppColors.current.text200;
    }
  }

  Color get hintColor {
    switch (this) {
      case TextInputState.inactive:
        return AppColors.current.text300;
      case TextInputState.filled:
      case TextInputState.active:
      case TextInputState.error:
        return AppColors.current.text100;
      case TextInputState.disabled:
        return AppColors.current.neutral700;
    }
  }
}
