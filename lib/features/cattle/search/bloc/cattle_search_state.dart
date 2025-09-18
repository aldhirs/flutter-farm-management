import 'package:farm/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/features/cattle/search/model/list_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cattle_search_state.freezed.dart';

@freezed
abstract class CattleSearchState extends BaseBlocState
    with _$CattleSearchState {
  const factory CattleSearchState({
    @Default('') String earTag,
    @Default(null) Cattle? cattle,
    @Default([]) List<ListItem> listItems,
    @Default('') String successMessage,
    @Default('') String errorMessage,
    @Default(false) bool loading,
  }) = _CattleSearchState;
  const CattleSearchState._();
}
