import 'package:farm/domain/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'discover_summary_request.freezed.dart';
part 'discover_summary_request.g.dart';

/// Kunci kueri dieja `project`, bukan `id_project`.
///
/// Dua-duanya dibaca middleware ProjectAccess di server, tetapi handler
/// discover-summary membaca `project` — sama seperti work-summary yang sudah
/// lebih dulu ada.
@freezed
abstract class DiscoverSummaryRequest extends BaseInput
    with _$DiscoverSummaryRequest {
  const factory DiscoverSummaryRequest({
    @JsonKey(name: 'client_slug') @Default('') String clientSlug,
    @JsonKey(name: 'project') @Default('') String project,
  }) = _DiscoverSummaryRequest;
  const DiscoverSummaryRequest._();

  factory DiscoverSummaryRequest.fromJson(Map<String, dynamic> json) =>
      _$DiscoverSummaryRequestFromJson(json);
}
