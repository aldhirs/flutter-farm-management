import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/pen/pen.dart';
import 'package:farm/domain/entities/pen/pen_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'pens_use_case.freezed.dart';

@Injectable()
class PensUseCase extends BaseFutureUseCase<PenRequest, PensOutput> {
  const PensUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<PensOutput> buildUseCase(PenRequest input) async {
    final response = await _repository.pens(input);
    final result = responseListMapper(response);
    return PensOutput(
      result: result,
      page: response.page,
      total_page: response.total_page,
    );
  }
}

@freezed
abstract class PensOutput extends BaseOutput with _$PensOutput {
  const PensOutput._();

  const factory PensOutput({
    DomainState<List<Pen>>? result,
    int? total_page,
    int? page,
  }) = _PensOutput;
}
