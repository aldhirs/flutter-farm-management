import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/sales/sale_id_request.dart';
import 'package:farm/domain/entities/sales/sales_request.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sale_by_id_use_case.freezed.dart';

@Injectable()
class SaleByIdUseCase extends BaseFutureUseCase<SaleIdRequest, SaleIdOutput> {
  const SaleByIdUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<SaleIdOutput> buildUseCase(SaleIdRequest input) async {
    final response = await _repository.saleByID(input);
    final result = responseMapper(response);
    return SaleIdOutput(result: result);
  }
}

@freezed
abstract class SaleIdOutput extends BaseOutput with _$SaleIdOutput {
  const SaleIdOutput._();

  const factory SaleIdOutput({DomainState<Sales>? result}) = _SaleIdOutput;
}
