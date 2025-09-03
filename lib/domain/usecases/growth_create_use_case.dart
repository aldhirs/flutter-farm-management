import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/growth/growth.dart';
import 'package:farm/domain/entities/growth/growth_form_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'growth_create_use_case.freezed.dart';

@Injectable()
class GrowthCreateUseCase
    extends BaseFutureUseCase<GrowthFormRequest, GrowthCreateOutput> {
  const GrowthCreateUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<GrowthCreateOutput> buildUseCase(GrowthFormRequest input) async {
    final response = await _repository.growthCreate(input);
    final result = responseMapper(response);
    return GrowthCreateOutput(result: result);
  }
}

@freezed
abstract class GrowthCreateOutput extends BaseOutput with _$GrowthCreateOutput {
  const GrowthCreateOutput._();

  const factory GrowthCreateOutput({DomainState<Growth>? result}) =
      _GrowthCreateOutput;
}
