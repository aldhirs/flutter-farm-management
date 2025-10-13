import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/reception/reception.dart';
import 'package:farm/domain/entities/reception/reception_assignee.dart';
import 'package:farm/domain/entities/reception/reception_assignee_request.dart';
import 'package:farm/domain/entities/reception/reception_request.dart';
import 'package:farm/domain/entities/supplier/supplier.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'reception_assignees_use_case.freezed.dart';

@Injectable()
class ReceptionAssigneesUseCase
    extends
        BaseFutureUseCase<ReceptionAssigneeRequest, ReceptionAssigneesOutput> {
  const ReceptionAssigneesUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<ReceptionAssigneesOutput> buildUseCase(
    ReceptionAssigneeRequest input,
  ) async {
    final response = await _repository.receptionAssignees(input);
    final result = responseListMapper(response);
    return ReceptionAssigneesOutput(result: result);
  }
}

@freezed
abstract class ReceptionAssigneesOutput extends BaseOutput
    with _$ReceptionAssigneesOutput {
  const ReceptionAssigneesOutput._();

  const factory ReceptionAssigneesOutput({
    DomainState<List<ReceptionAssignee>>? result,
  }) = _ReceptionAssigneesOutput;
}
