import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_state.freezed.dart';

@freezed
abstract class SalesState extends BaseBlocState with _$SalesState {
  const factory SalesState({
    @Default('') String filterStatus,
    @Default([]) List<Sales> sales,
    @Default('') String errorMessage,
    @Default(false) bool isLoadMore,
    @Default(false) bool hasMore,
  }) = _SalesState;
  const SalesState._();
}
