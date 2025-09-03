import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/medical/medical_type.dart';
import 'package:farm/domain/entities/medical/medical_type_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'medical_types_use_case.freezed.dart';

@Injectable()
class MedicalTypesUseCase
    extends BaseFutureUseCase<MedicalTypeRequest, MedicalTypeOutput> {
  const MedicalTypesUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<MedicalTypeOutput> buildUseCase(MedicalTypeRequest input) async {
    final response = await _repository.medicalTypes(input);
    final result = responseListMapper(response);
    return MedicalTypeOutput(result: result);
  }
}

@freezed
abstract class MedicalTypeOutput extends BaseOutput with _$MedicalTypeOutput {
  const MedicalTypeOutput._();

  const factory MedicalTypeOutput({DomainState<List<MedicalType>>? result}) =
      _MedicalTypeOutput;
}
