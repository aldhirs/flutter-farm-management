import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation_item_add_request.freezed.dart';
part 'mutation_item_add_request.g.dart';

@freezed
abstract class MutationItemAddRequest extends BaseInput
    with _$MutationItemAddRequest {
  const factory MutationItemAddRequest({
    @Default('') String id_mutation,
    @Default([]) List<String> id_cattles,
  }) = _MutationItemAddRequest;

  const MutationItemAddRequest._();

  factory MutationItemAddRequest.fromJson(Map<String, dynamic> json) =>
      _$MutationItemAddRequestFromJson(json);
}
