import 'package:freezed_annotation/freezed_annotation.dart';

part 'domain_state.freezed.dart';

@freezed
sealed class DomainState<T> with _$DomainState<T> {
  const factory DomainState.success(T data, String? message) = DataSuccess;
  const factory DomainState.error(String? errorMessage) = DataError;
}
