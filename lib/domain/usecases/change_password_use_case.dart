import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/auth/change_password_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'change_password_use_case.freezed.dart';

@Injectable()
class ChangePasswordUseCase
    extends BaseFutureUseCase<ChangePasswordRequest, ChangePasswordOutput> {
  const ChangePasswordUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<ChangePasswordOutput> buildUseCase(
    ChangePasswordRequest input,
  ) async {
    final response = await _repository.changePassword(input);
    final result = responseMapper(response);
    return ChangePasswordOutput(result: result);
  }
}

@freezed
abstract class ChangePasswordOutput extends BaseOutput
    with _$ChangePasswordOutput {
  const ChangePasswordOutput._();

  const factory ChangePasswordOutput({DomainState<void>? result}) =
      _ChangePasswordOutput;
}
