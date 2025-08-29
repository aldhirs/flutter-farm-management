import 'package:farm/base/log/mixin/log_mixin.dart';
import 'package:farm/domain/base/base.dart';
import 'package:meta/meta.dart';

abstract class BaseUseCase<Input extends BaseInput, Output> with LogMixin {
  const BaseUseCase();

  @protected
  Output buildUseCase(Input input);
}
