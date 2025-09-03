import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/growth/growth_form_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'growth_update_use_case.freezed.dart';

@Injectable()
class GrowthUpdateUseCase
    extends BaseFutureUseCase<GrowthFormRequest, GrowthUpdateOutput> {
  const GrowthUpdateUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<GrowthUpdateOutput> buildUseCase(GrowthFormRequest input) async {
    final response = await _repository.growthUpdate(input);
    final result = responseMapper(response);
    return GrowthUpdateOutput(result: result);
  }
}

@freezed
abstract class GrowthUpdateOutput extends BaseOutput with _$GrowthUpdateOutput {
  const GrowthUpdateOutput._();

  const factory GrowthUpdateOutput({DomainState<void>? result}) =
      _GrowthUpdateOutput;
}
