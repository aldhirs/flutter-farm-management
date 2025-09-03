import 'package:freezed_annotation/freezed_annotation.dart';

part 'date_picker_model.freezed.dart';

@freezed
abstract class DatePickerModel with _$DatePickerModel {
  const factory DatePickerModel({
    @Default(0) int day,
    @Default(0) int month,
    @Default(0) int year,
  }) = _DatePickerModel;
}
