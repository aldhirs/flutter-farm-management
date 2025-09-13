import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reception_request.freezed.dart';
part 'reception_request.g.dart';

@freezed
abstract class ReceptionRequest extends BaseInput with _$ReceptionRequest {
  const factory ReceptionRequest({
    @Default('') String client_slug,
    @Default('') String search,
    @Default(1) int page,
    @Default(50) int limit,
  }) = _ReceptionRequest;
  const ReceptionRequest._();

  factory ReceptionRequest.fromJson(Map<String, dynamic> json) =>
      _$ReceptionRequestFromJson(json);
}
