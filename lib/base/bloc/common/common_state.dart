import 'package:farm/base/base.dart';
import 'package:farm/base/exception/base/app_exception_wrapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_state.freezed.dart';

@freezed
abstract class CommonState extends BaseBlocState with _$CommonState {
  const factory CommonState({
    AppExceptionWrapper? appExceptionWrapper,
    @Default(0) int loadingCount,
    @Default(false) bool isLoading,
  }) = _CommonState;
  const CommonState._();
}
