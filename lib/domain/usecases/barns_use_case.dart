import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/barn/barn_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'barns_use_case.freezed.dart';

@Injectable()
class BarnsUseCase extends BaseFutureUseCase<BarnRequest, BarnsOutput> {
  const BarnsUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<BarnsOutput> buildUseCase(BarnRequest input) async {
    final response = await _repository.barns(input);
    final result = responseListMapper(response);
    return BarnsOutput(result: result);
  }
}

@freezed
abstract class BarnsOutput extends BaseOutput with _$BarnsOutput {
  const BarnsOutput._();

  const factory BarnsOutput({DomainState<List<Barn>>? result}) = _BarnsOutput;
}
