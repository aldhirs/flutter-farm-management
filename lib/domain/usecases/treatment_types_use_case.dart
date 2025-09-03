import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/treatment/treatment_type.dart';
import 'package:farm/domain/entities/treatment/treatment_type_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'treatment_types_use_case.freezed.dart';

@Injectable()
class TreatmentTypesUseCase
    extends BaseFutureUseCase<TreatmentTypeRequest, TreatmentTypesOutput> {
  const TreatmentTypesUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<TreatmentTypesOutput> buildUseCase(TreatmentTypeRequest input) async {
    final response = await _repository.treatmentTypes(input);
    final result = responseListMapper(response);
    return TreatmentTypesOutput(result: result);
  }
}

@freezed
abstract class TreatmentTypesOutput extends BaseOutput
    with _$TreatmentTypesOutput {
  const TreatmentTypesOutput._();

  const factory TreatmentTypesOutput({
    DomainState<List<TreatmentType>>? result,
  }) = _TreatmentTypesOutput;
}
