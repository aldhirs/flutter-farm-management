import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/domain/usecases/cattle_by_rfid_use_case.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class CattleByEarTagUseCase
    extends BaseFutureUseCase<CattleRequest, CattleOutput> {
  const CattleByEarTagUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<CattleOutput> buildUseCase(CattleRequest input) async {
    final response = await _repository.cattleByEarTag(input);
    final result = responseMapper(response);
    return CattleOutput(result: result);
  }
}
