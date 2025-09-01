import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/auth/login_request.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'login_use_case.freezed.dart';

@Injectable()
class LoginUseCase extends BaseFutureUseCase<LoginRequest, LoginOutput> {
  const LoginUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<LoginOutput> buildUseCase(LoginRequest input) async {
    final response = await _repository.login(input);
    final result = responseMapper(response);
    return LoginOutput(result: result);
  }
}

@freezed
abstract class LoginOutput extends BaseOutput with _$LoginOutput {
  const LoginOutput._();

  const factory LoginOutput({DomainState<UserData>? result}) = _LoginOutput;
}
