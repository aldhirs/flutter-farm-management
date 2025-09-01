import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/barn/barn.dart';
import 'package:farm/domain/entities/barn/barn_request.dart';
import 'package:farm/domain/entities/cattle/cattle_form_request.dart';
import 'package:farm/domain/entities/general/empty_response.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'cattle_update_use_case.freezed.dart';

@Injectable()
class CattleUpdateUseCase
    extends BaseFutureUseCase<CattleFormRequest, CattleUpdateOutput> {
  const CattleUpdateUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<CattleUpdateOutput> buildUseCase(CattleFormRequest input) async {
    final response = await _repository.cattleUpdate(input);
    final result = responseMapper(response);
    return CattleUpdateOutput(result: result);
  }
}

@freezed
abstract class CattleUpdateOutput extends BaseOutput with _$CattleUpdateOutput {
  const CattleUpdateOutput._();

  const factory CattleUpdateOutput({DomainState<void>? result}) =
      _CattleUpdateOutput;
}
