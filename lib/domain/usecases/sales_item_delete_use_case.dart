import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/sales/sales_item_delete_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sales_item_delete_use_case.freezed.dart';

@Injectable()
class SalesItemDeleteUseCase
    extends BaseFutureUseCase<SalesItemDeleteRequest, SalesItemDeleteOutput> {
  const SalesItemDeleteUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<SalesItemDeleteOutput> buildUseCase(
    SalesItemDeleteRequest input,
  ) async {
    final response = await _repository.salesItemDelete(input);
    final result = responseMapper(response);
    return SalesItemDeleteOutput(result: result);
  }
}

@freezed
abstract class SalesItemDeleteOutput extends BaseOutput
    with _$SalesItemDeleteOutput {
  const SalesItemDeleteOutput._();

  const factory SalesItemDeleteOutput({DomainState<void>? result}) =
      _SalesItemDeleteOutput;
}
