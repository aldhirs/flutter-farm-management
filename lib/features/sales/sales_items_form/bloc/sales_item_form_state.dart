import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_item_form_state.freezed.dart';

@freezed
abstract class SalesItemFormState extends BaseBlocState
    with _$SalesItemFormState {
  const factory SalesItemFormState({
    @Default(Sales()) Sales sales,
    @Default([]) List<Cattle> items,
    @Default([]) List<Barn> barns,
    @Default([]) List<Pen> pens,
    @Default([]) List<Cattle> selectedItems,
    @Default(null) Barn? selectedBarn,
    @Default(false) bool loading,
    @Default(null) Pen? selectedPen,
    @Default('') String errorMessage,
    @Default('') String errorSnackMessage,
    @Default(false) bool isLoadMore,
    @Default(false) bool isSuccessSave,
    @Default(false) bool hasMore,
  }) = _SalesItemFormState;
  const SalesItemFormState._();
}
