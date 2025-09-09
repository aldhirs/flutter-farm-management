import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cattle_pen_to_pen_request.freezed.dart';
part 'cattle_pen_to_pen_request.g.dart';

@freezed
abstract class CattlePenToPenRequest extends BaseInput
    with _$CattlePenToPenRequest {
  const factory CattlePenToPenRequest({
    @Default('') String from_pen_id,
    @Default('') String to_pen_id,
  }) = _CattlePenToPenRequest;
  const CattlePenToPenRequest._();

  factory CattlePenToPenRequest.fromJson(Map<String, dynamic> json) =>
      _$CattlePenToPenRequestFromJson(json);
}
