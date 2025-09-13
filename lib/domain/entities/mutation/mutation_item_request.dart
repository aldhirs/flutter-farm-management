import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation_item_request.freezed.dart';
part 'mutation_item_request.g.dart';

@freezed
abstract class MutationItemRequest extends BaseInput
    with _$MutationItemRequest {
  const factory MutationItemRequest({
    @Default('') String id_mutation,
    @Default(1) int page,
    @Default(20) int limit,
  }) = _MutationItemRequest;

  const MutationItemRequest._();

  factory MutationItemRequest.fromJson(Map<String, dynamic> json) =>
      _$MutationItemRequestFromJson(json);
}
