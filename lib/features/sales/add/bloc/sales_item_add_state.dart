import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/features/sales/add/model/list_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_item_add_state.freezed.dart';

@freezed
abstract class SalesItemAddState extends BaseBlocState
    with _$SalesItemAddState {
  const factory SalesItemAddState({
    @Default('') String rfid,
    @Default(Sales()) Sales sale,
    @Default(UserData()) UserData userData,
    @Default(Cattle()) Cattle cattle,
    @Default([]) List<Barn> barns,
    @Default([]) List<Pen> pens,
    @Default(false) bool loading,
    @Default(false) bool bottomsheetLoading,
    @Default('') String errorMessage,
    @Default([]) List<ListItem> listItems,
    @Default(false) bool isSuccess,

    @Default(null) Barn? selectedBarn,
    @Default(null) Pen? selectedPen,
    @Default(null) String? weight,
  }) = _SalesItemAddState;

  const SalesItemAddState._();
}
