import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_item.freezed.dart';

@freezed
abstract class ListItem with _$ListItem {
  const factory ListItem({
    @Default('') String name,
    @Default('') String description,
    @Default(null) Widget? icon,
    VoidCallback? action,
  }) = _ListItem;
}
