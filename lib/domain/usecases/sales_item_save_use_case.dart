import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/sales/sales_item_save_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sales_item_save_use_case.freezed.dart';

@Injectable()
class SalesItemSaveUseCase
    extends BaseFutureUseCase<SalesItemSaveRequest, SalesItemSaveOutput> {
  const SalesItemSaveUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<SalesItemSaveOutput> buildUseCase(SalesItemSaveRequest input) async {
    final response = await _repository.salesItemSave(input);
    final result = responseMapper(response);
    return SalesItemSaveOutput(result: result);
  }
}

@freezed
abstract class SalesItemSaveOutput extends BaseOutput
    with _$SalesItemSaveOutput {
  const SalesItemSaveOutput._();

  const factory SalesItemSaveOutput({DomainState<void>? result}) =
      _SalesItemSaveOutput;
}
