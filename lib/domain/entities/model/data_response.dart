import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class DataResponse<T> {
  DataResponse({
    @JsonKey(name: 'status') this.status,
    @JsonKey(name: 'message') this.message,
    @JsonKey(name: 'data') this.data,
    @JsonKey(name: 'total') this.total,
    @JsonKey(name: 'total_page') this.total_page,
    @JsonKey(name: 'page') this.page,
    @JsonKey(name: 'per_page') this.per_page,
  });

  // ignore: avoid-dynamic
  factory DataResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) => _$DataResponseFromJson(json, fromJsonT);

  final bool? status;
  final String? message;
  final T? data;
  final int? total;
  final int? total_page;
  final int? page;
  final int? per_page;
}

@JsonSerializable(genericArgumentFactories: true)
class DataListResponse<T> {
  DataListResponse({
    @JsonKey(name: 'status') this.status,
    @JsonKey(name: 'message') this.message,
    @JsonKey(name: 'total_page') this.total_page,
    @JsonKey(name: 'per_page') this.per_page,
    @JsonKey(name: 'page') this.page,
    @JsonKey(name: 'total') this.total,
    @JsonKey(name: 'data') this.data,
  });

  // ignore: avoid-dynamic
  factory DataListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) => _$DataListResponseFromJson(json, fromJsonT);

  final bool? status;
  final String? message;
  final int? total_page;
  final int? per_page;
  final int? total;
  final int? page;
  final List<T>? data;
}
