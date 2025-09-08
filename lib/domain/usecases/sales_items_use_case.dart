import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/sales/sales_item.dart';
import 'package:farm/domain/entities/sales/sales_item_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sales_items_use_case.freezed.dart';

@Injectable()
class SalesItemsUseCase
    extends BaseFutureUseCase<SalesItemRequest, SalesItemsOutput> {
  const SalesItemsUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<SalesItemsOutput> buildUseCase(SalesItemRequest input) async {
    final response = await _repository.salesItems(input);
    final result = responseListMapper(response);
    return SalesItemsOutput(
      result: result,
      total_page: response.total_page,
      page: response.page,
    );
  }
}

@freezed
abstract class SalesItemsOutput extends BaseOutput with _$SalesItemsOutput {
  const SalesItemsOutput._();

  const factory SalesItemsOutput({
    DomainState<List<SalesItem>>? result,
    int? total_page,
    int? page,
  }) = _SalesItemsOutput;
}
