import 'package:dartx/dartx_io.dart';
import 'package:farm/extensions/int.dart';
import 'package:farm/navigation/app_navigator.dart';
import 'package:farm/resources/resource.dart';
import 'package:farm/utils/ui_utils.dart';
import 'package:farm/widgets/buttons/button.dart';
import 'package:farm/widgets/datepicker/date_picker_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerView extends StatefulWidget {
  final void Function(DatePickerModel?)? onDateChanged;

  const DatePickerView({
    super.key,
    this.onDateChanged,
    required this.navigator,
    this.labelText,
    this.datePickerType = DatePickerType.datePicker,
    this.currentDateTime,
  });
  final AppNavigator navigator;
  final String? labelText;
  final DatePickerType datePickerType;
  final DateTime? currentDateTime;

  @override
  State<DatePickerView> createState() => _DatePickerViewState();
}

class _DatePickerViewState extends State<DatePickerView> {
  final List<int> years = List.generate(
    2100 - 1900 + 1,
    (index) => 1900 + index,
  );
  final List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];
  final List<int> days = List.generate(31, (index) => index + 1);

  int? selectedDay;
  int? selectedMonth;
  int? selectedYear;
  DatePickerModel? datePickerModel = const DatePickerModel();

  final double _pickerHeight = 200;
  final double _itemExtent = 40;

  bool dateHasChanged = false;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.currentDateTime?.day ?? DateTime.now().day;
    selectedMonth = widget.currentDateTime?.month != null
        ? widget.currentDateTime!.month.defaultZero() - 1
        : DateTime.now().month - 1;
    selectedYear = widget.currentDateTime?.year ?? DateTime.now().year;

    if (widget.currentDateTime != null) {
      dateHasChanged = true;
    }
    _updateDays();
  }

  void _onReset() {
    dateHasChanged = false;
    widget.onDateChanged!(null);
    widget.navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: Dimens.d16,
            right: Dimens.d16,
            top: Dimens.d16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.labelText.orEmpty(), style: TextStyles.body2()),
              GestureDetector(
                onTap: dateHasChanged ? _onReset : null,
                child: Text(
                  "Reset",
                  style: TextStyles.label1().copyWith(
                    color: dateHasChanged
                        ? AppColors.current.royalNavy500
                        : AppColors.current.text300,
                  ),
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Positioned(
              top: (_pickerHeight - _itemExtent) / 2,
              left: 12,
              right: 12,
              height: _itemExtent,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.current.royalNavy100,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),

            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.datePickerType == DatePickerType.datePicker) ...[
                    _buildFlatPicker(
                      items: days.map((e) => e.toString()).toList(),
                      selectedIndex: selectedDay.defaultZero() - 1,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedDay = days[index];
                        });
                      },
                    ),
                    _buildFlatPicker(
                      items: months,
                      selectedIndex: selectedMonth.defaultZero(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedMonth = index;
                          _updateDays();
                        });
                      },
                    ),
                  ],
                  _buildFlatPicker(
                    items: years.map((e) => e.toString()).toList(),
                    selectedIndex: years.indexOf(selectedYear.defaultZero()),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedYear = years[index];
                        _updateDays();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.d16,
            vertical: Dimens.d10,
          ),
          child: Button(
            type: ButtonType.primary,
            text: 'Terapkan',
            fulLWidth: true,
            onPressed: () {
              datePickerModel = datePickerValue();
              widget.onDateChanged?.call(datePickerModel);
              widget.navigator.pop();
            },
          ),
        ),
      ],
    );
  }

  DatePickerModel datePickerValue() {
    if (widget.datePickerType == DatePickerType.datePicker) {
      return DatePickerModel(
        day: selectedDay.defaultZero(),
        month: selectedMonth.defaultZero(),
        year: selectedYear.defaultZero(),
      );
    } else {
      return DatePickerModel(year: selectedYear.defaultZero());
    }
  }

  void _updateDays() {
    int daysInMonth = 31;
    if (selectedMonth == 1) {
      daysInMonth = isLeapYear(selectedYear.defaultZero()) ? 29 : 28;
    } else if ([3, 5, 8, 10].contains(selectedMonth)) {
      daysInMonth = 30;
    }

    setState(() {
      days.clear();
      days.addAll(List.generate(daysInMonth, (index) => index + 1));
      if (selectedDay.defaultZero() > daysInMonth) {
        selectedDay = daysInMonth;
      }
    });
  }

  bool isLeapYear(int year) {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  Widget _buildFlatPicker({
    required List<String> items,
    required int selectedIndex,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    return SizedBox(
      width: 100,
      height: _pickerHeight,
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: selectedIndex,
        ),
        itemExtent: _itemExtent,
        selectionOverlay: null,
        diameterRatio: 1000,
        magnification: 1.0,
        useMagnifier: false,
        squeeze: 1.2,
        onSelectedItemChanged: onSelectedItemChanged,
        children: items.map((item) {
          int index = items.indexOf(item);
          Color itemColor = Colors.black;
          if (index == selectedIndex) {
            itemColor = AppColors.current.royalNavy500;
          } else if (index == selectedIndex - 1 || index == selectedIndex + 1) {
            itemColor = AppColors.current.text300;
          } else if (index >= selectedIndex - 1 || index <= items.length - 1) {
            itemColor = AppColors.current.neutral500;
          }

          return Center(
            child: Text(
              item,
              style: TextStyles.body2().copyWith(color: itemColor),
            ),
          );
        }).toList(),
      ),
    );
  }
}

enum DatePickerType { yearPicker, datePicker }
