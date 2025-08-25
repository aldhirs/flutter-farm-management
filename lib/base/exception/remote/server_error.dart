import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_error.freezed.dart';

@freezed
abstract class ServerError with _$ServerError {
  const factory ServerError({
    /// server-defined status code
    int? generalServerStatusCode,

    /// server-defined error id
    String? generalServerErrorId,

    /// server-defined message
    String? generalMessage,
  }) = _ServerError;
}
