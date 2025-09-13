import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/mutation/mutation_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation_item_delete_request.freezed.dart';
part 'mutation_item_delete_request.g.dart';

@freezed
abstract class MutationItemDeleteRequest extends BaseInput
    with _$MutationItemDeleteRequest {
  const factory MutationItemDeleteRequest({
    @Default('') String id_mutation,
    @Default([]) List<MutationItem> items,
  }) = _MutationItemDeleteRequest;

  const MutationItemDeleteRequest._();

  factory MutationItemDeleteRequest.fromJson(Map<String, dynamic> json) =>
      _$MutationItemDeleteRequestFromJson(json);
}
