import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/cattle/cattle_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'cattle_by_rfid_use_case.freezed.dart';

@Injectable()
class CattleByRFIDUseCase
    extends BaseFutureUseCase<CattleRequest, CattleOutput> {
  const CattleByRFIDUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<CattleOutput> buildUseCase(CattleRequest input) async {
    final response = await _repository.cattleByRFID(input);
    final result = responseMapper(response);
    return CattleOutput(result: result);
  }
}

@freezed
abstract class CattleOutput extends BaseOutput with _$CattleOutput {
  const CattleOutput._();

  const factory CattleOutput({DomainState<Cattle>? result}) = _CattleOutput;
}
