import 'package:dartx/dartx_io.dart';
import 'package:farm/constants/date_constant.dart';
import 'package:farm/extensions/bool.dart';
import 'package:farm/extensions/int.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/string_utils.dart';
import 'package:farm/widgets/datepicker/date_picker_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';

class DatePickerInputWidget extends StatefulWidget {
  DatePickerInputWidget({
    super.key,
    this.textFormFieldKey,
    this.label = '',
    this.datePickerLabel = '',
    this.initialValue,
    this.hintText = '',
    this.prefixIcon,
    this.customSuffixIcon,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.obscureText = false,
    this.enableToggleObscure = false,
    this.datePickerInputState,
    this.maxLength,
    this.maxLines = 1,
    this.errorText = '',
    this.enableInteractiveSelection = false,
    this.inputFormatter,
    this.onTap,
    this.successTextInfo,
    this.additionalInfo,
    this.enabled,
    this.isShowDatePicker = false,
    required this.navigator,
    this.datePickerType = DatePickerType.datePicker,
    this.onApplyDate,
    this.formatDate = DateConstant.DATE_FULL_MONTH,
  });

  final AppNavigator navigator;
  final Key? textFormFieldKey;
  final String label;
  final String datePickerLabel;
  final String hintText;
  final String errorText;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? customSuffixIcon;
  bool? isShowDatePicker;
  final void Function(String)? onChanged;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  bool obscureText;
  final bool enableToggleObscure;
  DatePickerInputState? datePickerInputState;
  final int? maxLength;
  final int? maxLines;
  final bool? enableInteractiveSelection;
  final List<TextInputFormatter>? inputFormatter;
  final void Function()? onTap;
  final String? successTextInfo;
  final String? additionalInfo;
  final bool? enabled;
  final DatePickerType datePickerType;
  final String formatDate;
  final void Function(String, DateTime?)? onApplyDate;

  @override
  State<DatePickerInputWidget> createState() => _DatePickerInputFieldState();
}

class _DatePickerInputFieldState extends State<DatePickerInputWidget> {
  final _borderRadius = BorderRadius.circular(Dimens.d8);
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.datePickerInputState = DatePickerInputState.inactive;
    _focusNode.addListener(() {
      setState(() {
        if (_focusNode.hasFocus) {
          widget.datePickerInputState = DatePickerInputState.active;
          widget.isShowDatePicker = true;
        } else {
          widget.datePickerInputState = DatePickerInputState.inactive;
          widget.isShowDatePicker = false;
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
          onTap: () {
            widget.navigator.showBottomSheet(
              DatePickerView(
                currentDateTime: (widget.controller?.text).orEmpty().isNotEmpty
                    ? (widget.controller?.text).orEmpty().parseToDate(
                        format: widget.formatDate,
                      )
                    : null,
                labelText: widget.datePickerLabel,
                navigator: widget.navigator,
                datePickerType: widget.datePickerType,
                onDateChanged: (dateValue) {
                  if (widget.controller != null) {
                    var dateTime = null;
                    if (dateValue != null) {
                      dateTime = DateTime(
                        dateValue.year.defaultZero(),
                        dateValue.month.defaultZero() + 1,
                        dateValue.day.defaultZero(),
                      );
                      var parseDate =
                          "${dateValue.day} ${DateFormat('MMMM', 'id_ID').format(dateTime)} ${dateValue.year} ";
                      widget.controller!.setText(
                        dateValue.day == 0 && dateValue.month == 0
                            ? '${dateValue.year}'
                            : parseDate,
                      );
                    } else {
                      widget.controller?.setText('');
                    }
                    if (widget.onApplyDate != null) {
                      widget.onApplyDate!(widget.controller!.text, dateTime);
                    }
                  }
                },
              ),
            );
          },
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
                      color: widget.datePickerInputState?.hintColor,
                    ),
                  ),
                )
              : null,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelStyle: TextStyles.label1().copyWith(
              color: (widget.isShowDatePicker.defaultFalse()
                  ? AppColors.current.mint700
                  : AppColors.current.text300),
            ),
            labelText: widget.label,
            hintText: _focusNode.hasFocus ? '' : widget.hintText,
            hintStyle: TextStyles.label1().copyWith(
              color: widget.datePickerInputState?.hintColor,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: const Align(
              widthFactor: Dimens.d1,
              heightFactor: Dimens.d1,
              child: Icon(Icons.calendar_month_outlined),
            ),
            error: _errorText(),
            enabledBorder: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(
                color: (widget.isShowDatePicker.defaultFalse()
                    ? AppColors.current.mint700
                    : AppColors.current.neutral700),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(
                color: (widget.isShowDatePicker.defaultFalse()
                    ? AppColors.current.mint700
                    : AppColors.current.neutral700),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(
                color: (widget.isShowDatePicker.defaultFalse()
                    ? AppColors.current.mint700
                    : AppColors.current.neutral700),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(
                color: (widget.isShowDatePicker.defaultFalse()
                    ? AppColors.current.mint700
                    : AppColors.current.neutral700),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(
                color: (widget.isShowDatePicker.defaultFalse()
                    ? AppColors.current.mint700
                    : AppColors.current.neutral700),
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(color: AppColors.current.neutral500),
            ),
          ),
        ),
        const SizedBox(height: 2.0),
        Visibility(
          visible:
              widget.additionalInfo != null &&
              widget.errorText.isEmpty &&
              widget.successTextInfo == null &&
              widget.datePickerInputState != DatePickerInputState.error,
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
              widget.datePickerInputState != DatePickerInputState.error,
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
              widget.datePickerInputState == DatePickerInputState.error,
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

  Widget? _errorText() {
    if (widget.datePickerInputState == DatePickerInputState.error) {
      return const SizedBox();
    }
    return null;
  }
}

enum DatePickerInputState {
  inactive,
  active,
  filled,
  error,
  disabled;

  Color get borderColor {
    switch (this) {
      case DatePickerInputState.inactive:
        return AppColors.current.neutral500;
      case DatePickerInputState.filled:
      case DatePickerInputState.active:
        return AppColors.current.mint700;
      case DatePickerInputState.error:
        return AppColors.current.crimson500;
      case DatePickerInputState.disabled:
        return AppColors.current.neutral700;
    }
  }

  Color get labelColor {
    switch (this) {
      case DatePickerInputState.inactive:
        return AppColors.current.text300;
      case DatePickerInputState.filled:
      case DatePickerInputState.active:
        return AppColors.current.mint700;
      case DatePickerInputState.error:
        return AppColors.current.crimson500;
      case DatePickerInputState.disabled:
        return AppColors.current.neutral700;
    }
  }

  Color get additionalInfoColor {
    switch (this) {
      case DatePickerInputState.inactive:
      case DatePickerInputState.filled:
      case DatePickerInputState.active:
        return AppColors.current.text300;
      case DatePickerInputState.error:
        return AppColors.current.crimson500;
      case DatePickerInputState.disabled:
        return AppColors.current.text200;
    }
  }

  Color get hintColor {
    switch (this) {
      case DatePickerInputState.inactive:
        return AppColors.current.text300;
      case DatePickerInputState.filled:
      case DatePickerInputState.active:
      case DatePickerInputState.error:
        return AppColors.current.text100;
      case DatePickerInputState.disabled:
        return AppColors.current.neutral700;
    }
  }
}
