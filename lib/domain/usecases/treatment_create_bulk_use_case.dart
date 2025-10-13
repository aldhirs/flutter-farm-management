import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/treatment/treatment_bulk_form_request.dart';
import 'package:farm/domain/entities/treatment/treatment_form_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/domain/usecases/treatment_create_use_case.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class TreatmentCreateBulkUseCase
    extends BaseFutureUseCase<TreatmentBulkFormRequest, TreatmentCreateOutput> {
  const TreatmentCreateBulkUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<TreatmentCreateOutput> buildUseCase(
    TreatmentBulkFormRequest input,
  ) async {
    final response = await _repository.treatmentCreateBulk(input);
    final result = responseMapper(response);
    return TreatmentCreateOutput(result: result);
  }
}
