import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/base/base.dart';
import 'package:farm/widgets/tag/tag_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation.freezed.dart';
part 'mutation.g.dart';

@freezed
abstract class Mutation extends BaseOutput with _$Mutation {
  const factory Mutation({
    @Default('') String id,
    @Default('') String from_project_id,
    @Default('') String to_project_id,
    @Default('') String from_project_name,
    @Default('') String to_project_name,
    @Default(0) int created_by,
    @Default('') String status,
    @Default('') String created_at,
  }) = _Mutation;
  const Mutation._();
  factory Mutation.fromJson(Map<String, dynamic> json) =>
      _$MutationFromJson(json);

  String statusLabel() {
    if (status.isEmpty) {
      return '-';
    }
    return mutationStatusMap.entries
        .firstWhere((item) => item.key == status)
        .value;
  }

  bool isDraft() {
    return status == DRAFT;
  }

  TagCategoryType statusType() {
    switch (status) {
      case DRAFT:
        return TagCategoryType.gamboge;
      case ISSUED:
        return TagCategoryType.eucalyptus;
      case COMPLETED:
        return TagCategoryType.eucalyptus;
      case CANCELLED:
        return TagCategoryType.crismon;
    }
    return TagCategoryType.plain;
  }
}
