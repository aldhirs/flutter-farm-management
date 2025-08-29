import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/auth/user_data.dart';
import 'package:farm/domain/repositories/auth_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'get_user_data_use_case.freezed.dart';

@Injectable()
class GetUserDataUseCase extends BaseSyncUseCase<GetUserDataInput, UserData> {
  GetUserDataUseCase(this._repository);

  final AuthRepository _repository;

  @override
  UserData buildUseCase(GetUserDataInput input) {
    final user = _repository.getUserDataPreference();
    return user;
  }
}

@freezed
abstract class GetUserDataInput extends BaseInput with _$GetUserDataInput {
  const GetUserDataInput._();
  const factory GetUserDataInput() = _GetUserDataInput;
}
