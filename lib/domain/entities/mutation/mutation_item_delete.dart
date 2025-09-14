import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation_item_delete.freezed.dart';
part 'mutation_item_delete.g.dart';

@freezed
abstract class MutationItemDelete extends BaseOutput with _$MutationItemDelete {
  const factory MutationItemDelete({
    @Default('') String id_mutation_item,
    @Default('') String id_cattle,
  }) = _MutationItemDelete;

  const MutationItemDelete._();

  factory MutationItemDelete.fromJson(Map<String, dynamic> json) =>
      _$MutationItemDeleteFromJson(json);
}
