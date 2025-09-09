import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle_pen_to_pen_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'cattle_move_to_pen_use_case.freezed.dart';

@Injectable()
class CattleMoveToPenUseCase
    extends BaseFutureUseCase<CattlePenToPenRequest, CattleMoveToPenOutput> {
  const CattleMoveToPenUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<CattleMoveToPenOutput> buildUseCase(
    CattlePenToPenRequest input,
  ) async {
    final response = await _repository.cattleMovePenToPen(input);
    final result = responseMapper(response);
    return CattleMoveToPenOutput(result: result);
  }
}

@freezed
abstract class CattleMoveToPenOutput extends BaseOutput
    with _$CattleMoveToPenOutput {
  const CattleMoveToPenOutput._();

  const factory CattleMoveToPenOutput({DomainState<void>? result}) =
      _CattleMoveToPenOutput;
}
