import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/pen/pen_request.dart';
import 'package:farm/domain/entities/treatment/treatment.dart';
import 'package:farm/domain/entities/treatment/treatment_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'treatments_use_case.freezed.dart';

@Injectable()
class TreatmentsUseCase
    extends BaseFutureUseCase<TreatmentRequest, TreatmentsOutput> {
  const TreatmentsUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<TreatmentsOutput> buildUseCase(TreatmentRequest input) async {
    final response = await _repository.treatments(input);
    final result = responseListMapper(response);
    return TreatmentsOutput(
      result: result,
      page: response.page,
      total_page: response.total_page,
    );
  }
}

@freezed
abstract class TreatmentsOutput extends BaseOutput with _$TreatmentsOutput {
  const TreatmentsOutput._();

  const factory TreatmentsOutput({
    DomainState<List<Treatment>>? result,
    int? total_page,
    int? page,
  }) = _TreatmentsOutput;
}
