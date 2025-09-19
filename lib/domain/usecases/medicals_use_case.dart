import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/medical/medical.dart';
import 'package:farm/domain/entities/medical/medical_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'medicals_use_case.freezed.dart';

@Injectable()
class MedicalsUseCase
    extends BaseFutureUseCase<MedicalRequest, MedicalsOutput> {
  const MedicalsUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<MedicalsOutput> buildUseCase(MedicalRequest input) async {
    final response = await _repository.medicals(input);
    final result = responseListMapper(response);
    return MedicalsOutput(
      result: result,
      page: response.page,
      total_page: response.total_page,
    );
  }
}

@freezed
abstract class MedicalsOutput extends BaseOutput with _$MedicalsOutput {
  const MedicalsOutput._();

  const factory MedicalsOutput({
    DomainState<List<Medical>>? result,
    int? total_page,
    int? page,
  }) = _MedicalsOutput;
}
