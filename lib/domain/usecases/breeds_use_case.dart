import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/barn/barn_request.dart';
import 'package:farm/domain/entities/breed/breed.dart';
import 'package:farm/domain/entities/breed/breed_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'breeds_use_case.freezed.dart';

@Injectable()
class BreedsUseCase extends BaseFutureUseCase<BreedRequest, BreedOutput> {
  const BreedsUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<BreedOutput> buildUseCase(BreedRequest input) async {
    final response = await _repository.breeds(input);
    final result = responseListMapper(response);
    return BreedOutput(result: result);
  }
}

@freezed
abstract class BreedOutput extends BaseOutput with _$BreedOutput {
  const BreedOutput._();

  const factory BreedOutput({DomainState<List<Breed>>? result}) = _BreedOutput;
}
