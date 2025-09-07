import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/sales/sales_request.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sales_use_case.freezed.dart';

@Injectable()
class SalesUseCase extends BaseFutureUseCase<SalesRequest, SalesOutput> {
  const SalesUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<SalesOutput> buildUseCase(SalesRequest input) async {
    final response = await _repository.sales(input);
    final result = responseListMapper(response);
    return SalesOutput(
      result: result,
      total_page: response.total_page,
      page: response.page,
    );
  }
}

@freezed
abstract class SalesOutput extends BaseOutput with _$SalesOutput {
  const SalesOutput._();

  const factory SalesOutput({
    DomainState<List<Sales>>? result,
    int? total_page,
    int? page,
  }) = _SalesOutput;
}
