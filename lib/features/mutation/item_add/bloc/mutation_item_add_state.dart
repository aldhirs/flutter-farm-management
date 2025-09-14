import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/mutation/mutation.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/features/sales/add/model/list_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation_item_add_state.freezed.dart';

@freezed
abstract class MutationItemAddState extends BaseBlocState
    with _$MutationItemAddState {
  const factory MutationItemAddState({
    @Default('') String rfid,
    @Default(Mutation()) Mutation item,
    @Default(UserData()) UserData userData,
    @Default(Cattle()) Cattle cattle,
    @Default(false) bool loading,
    @Default(false) bool bottomsheetLoading,
    @Default('') String errorMessage,
    @Default([]) List<ListItem> listItems,
    @Default(false) bool isSuccess,
  }) = _MutationItemAddState;

  const MutationItemAddState._();
}
