import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/base/base.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation_item.freezed.dart';
part 'mutation_item.g.dart';

@freezed
abstract class MutationItem extends BaseOutput with _$MutationItem {
  const factory MutationItem({
    @Default('') String id,
    @Default('') String id_mutation,
    @Default('') String id_cattle,
    @Default('') String mutation_do_status,
    @Default('') String created_at,
  }) = _MutationItem;

  const MutationItem._();

  factory MutationItem.fromJson(Map<String, dynamic> json) =>
      _$MutationItemFromJson(json);

  String statusLabel() {
    if (mutation_do_status.isEmpty) return '-';
    return mutationItemStatusMap[mutation_do_status] ?? mutation_do_status;
  }

  TagCategoryType statusType() {
    switch (mutation_do_status) {
      case AVAILABLE:
        return TagCategoryType.eucalyptus;
      case BOOKED:
        return TagCategoryType.crismon;
    }
    return TagCategoryType.plain;
  }
}
