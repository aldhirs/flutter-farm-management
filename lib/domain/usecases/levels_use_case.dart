import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/level/level.dart';
import 'package:farm/domain/entities/level/level_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'levels_use_case.freezed.dart';

@Injectable()
class LevelsUseCase extends BaseFutureUseCase<LevelRequest, LevelsOutput> {
  const LevelsUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<LevelsOutput> buildUseCase(LevelRequest input) async {
    final response = await _repository.levels(input);
    final result = responseListMapper(response);
    return LevelsOutput(result: result);
  }
}

@freezed
abstract class LevelsOutput extends BaseOutput with _$LevelsOutput {
  const LevelsOutput._();

  const factory LevelsOutput({DomainState<List<Level>>? result}) =
      _LevelsOutput;
}
