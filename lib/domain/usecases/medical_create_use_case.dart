import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/medical/medical_form_request.dart';
import 'package:farm/domain/entities/treatment/treatment_form_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'medical_create_use_case.freezed.dart';

@Injectable()
class MedicalCreateUseCase
    extends BaseFutureUseCase<MedicalFormRequest, MedicalCreateOutput> {
  const MedicalCreateUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<MedicalCreateOutput> buildUseCase(MedicalFormRequest input) async {
    final response = await _repository.medicalCreate(input);
    final result = responseMapper(response);
    return MedicalCreateOutput(result: result);
  }
}

@freezed
abstract class MedicalCreateOutput extends BaseOutput
    with _$MedicalCreateOutput {
  const MedicalCreateOutput._();

  const factory MedicalCreateOutput({DomainState<void>? result}) =
      _MedicalCreateOutput;
}
