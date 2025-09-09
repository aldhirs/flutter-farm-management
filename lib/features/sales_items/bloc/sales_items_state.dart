import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/domain/entities/sales/sales_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_items_state.freezed.dart';

@freezed
abstract class SalesItemsState extends BaseBlocState with _$SalesItemsState {
  const factory SalesItemsState({
    @Default(Sales()) Sales sales,
    @Default([]) List<SalesItem> salesItems,
    @Default('') String errorMessage,
    @Default(false) bool isLoadMore,
    @Default(false) bool hasMore,
    @Default(false) bool isEditMode,
    @Default('') String successMessage,
    @Default([]) List<SalesItem> selectedItems,
  }) = _SalesItemsState;
  const SalesItemsState._();
}
