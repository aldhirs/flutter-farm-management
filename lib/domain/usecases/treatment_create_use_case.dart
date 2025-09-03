import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/treatment/treatment_form_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'treatment_create_use_case.freezed.dart';

@Injectable()
class TreatmentCreateUseCase
    extends BaseFutureUseCase<TreatmentFormRequest, TreatmentCreateOutput> {
  const TreatmentCreateUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<TreatmentCreateOutput> buildUseCase(TreatmentFormRequest input) async {
    final response = await _repository.treatmentCreate(input);
    final result = responseMapper(response);
    return TreatmentCreateOutput(result: result);
  }
}

@freezed
abstract class TreatmentCreateOutput extends BaseOutput
    with _$TreatmentCreateOutput {
  const TreatmentCreateOutput._();

  const factory TreatmentCreateOutput({DomainState<void>? result}) =
      _TreatmentCreateOutput;
}
