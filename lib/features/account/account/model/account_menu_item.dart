import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_menu_item.freezed.dart';

@freezed
abstract class AccountMenuItem with _$AccountMenuItem {
  const factory AccountMenuItem({
    @Default('') String name,
    @Default('') String description,
    @Default(null) Widget? icon,
    @Default('') String url,
    @Default(0) int section,
    VoidCallback? action,
  }) = _AccountMenuItem;
}
