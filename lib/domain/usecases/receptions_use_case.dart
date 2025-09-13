import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/reception/reception.dart';
import 'package:farm/domain/entities/reception/reception_request.dart';
import 'package:farm/domain/entities/supplier/supplier.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'receptions_use_case.freezed.dart';

@Injectable()
class ReceptionsUseCase
    extends BaseFutureUseCase<ReceptionRequest, ReceptionsOutput> {
  const ReceptionsUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<ReceptionsOutput> buildUseCase(ReceptionRequest input) async {
    final response = await _repository.receptions(input);
    final result = responseListMapper(response);
    return ReceptionsOutput(result: result);
  }
}

@freezed
abstract class ReceptionsOutput extends BaseOutput with _$ReceptionsOutput {
  const ReceptionsOutput._();

  const factory ReceptionsOutput({DomainState<List<Reception>>? result}) =
      _ReceptionsOutput;
}
