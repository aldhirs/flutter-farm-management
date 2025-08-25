import 'package:farm/base/base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'welcome_state.freezed.dart';

@freezed
abstract class WelcomeState extends BaseBlocState with _$WelcomeState {
  const factory WelcomeState({
    @Default(0) int appsVersionCode,
    @Default(0) int appsVersionCodeSaved,
  }) = _WelcomeState;
  const WelcomeState._();
}
