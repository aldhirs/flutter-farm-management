import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_request.freezed.dart';
part 'station_request.g.dart';

@freezed
abstract class StationRequest extends BaseInput with _$StationRequest {
  const factory StationRequest({@Default('') String id_reception}) =
      _StationRequest;
  const StationRequest._();

  factory StationRequest.fromJson(Map<String, dynamic> json) =>
      _$StationRequestFromJson(json);
}
