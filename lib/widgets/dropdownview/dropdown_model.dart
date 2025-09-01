import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dropdown_model.freezed.dart';

@freezed
abstract class DropdownCheckboxModel with _$DropdownCheckboxModel {
  const factory DropdownCheckboxModel({
    @Default('') String id,
    @Default('') String text,
    @Default('') String notes,
    @Default(Colors.transparent) Color color,
    @Default(false) bool selected,
  }) = _DropdownCheckboxModel;
}
