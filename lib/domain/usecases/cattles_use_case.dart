import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/cattle/cattle.dart';
import 'package:farm/domain/entities/cattle/cattle_list_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'cattles_use_case.freezed.dart';

@Injectable()
class CattlesUseCase
    extends BaseFutureUseCase<CattleListRequest, CattlesOutput> {
  const CattlesUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<CattlesOutput> buildUseCase(CattleListRequest input) async {
    final response = await _repository.cattles(input);
    final result = responseListMapper(response);
    return CattlesOutput(
      result: result,
      page: response.page,
      total_page: response.total_page,
    );
  }
}

@freezed
abstract class CattlesOutput extends BaseOutput with _$CattlesOutput {
  const CattlesOutput._();

  const factory CattlesOutput({
    DomainState<List<Cattle>>? result,
    int? page,
    int? total_page,
  }) = _CattlesOutput;
}
