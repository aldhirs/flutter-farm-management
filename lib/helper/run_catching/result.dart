import 'package:farm/base/exception/base/app_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T data) = ResultSuccess<T>;
  const factory Result.failure(AppException exception) = ResultError<T>;
}
