import 'package:farm/extensions/bool.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/widgets/datepicker/date_picker_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DateTimePickerInputWidget extends StatefulWidget {
  DateTimePickerInputWidget({
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
    required this.navigator,
    this.formatDateTime = "dd MMMM yyyy HH:mm",
    this.onApplyDateTime,
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
  DatePickerInputState? datePickerInputState;
  final void Function(String)? onChanged;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final bool enableToggleObscure;
  final int? maxLength;
  final int? maxLines;
  final bool? enableInteractiveSelection;
  final List<TextInputFormatter>? inputFormatter;
  final void Function()? onTap;
  final String? successTextInfo;
  final String? additionalInfo;
  final bool? enabled;
  final String formatDateTime;
  final void Function(String, DateTime?)? onApplyDateTime;

  @override
  State<DateTimePickerInputWidget> createState() =>
      _DateTimePickerInputFieldState();
}

class _DateTimePickerInputFieldState extends State<DateTimePickerInputWidget> {
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
        } else {
          widget.datePickerInputState = DatePickerInputState.inactive;
        }
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final now = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (selectedTime != null) {
        final dateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        final formatted = DateFormat(
          widget.formatDateTime,
          'id_ID',
        ).format(dateTime);
        widget.controller?.text = formatted;

        if (widget.onApplyDateTime != null) {
          widget.onApplyDateTime!(formatted, dateTime);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      showCursor: false,
      onTap: () => _pickDateTime(context),
      focusNode: _focusNode,
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: widget.keyboardType,
      enabled: widget.enabled.defaultTrue(),
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyles.label1().copyWith(
          color: (widget.datePickerInputState == DatePickerInputState.active
              ? AppColors.current.mint700
              : AppColors.current.text300),
        ),
        hintText: _focusNode.hasFocus ? '' : widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: const Icon(Icons.access_time),
        enabledBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(width: 2, color: AppColors.current.neutral700),
        ),
        border: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(width: 2, color: AppColors.current.neutral700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(width: 2, color: AppColors.current.mint700),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(width: 2, color: AppColors.current.neutral500),
        ),
      ),
    );
  }
}
