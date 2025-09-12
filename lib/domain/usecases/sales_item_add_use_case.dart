import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/sales/sales_item_add_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sales_item_add_use_case.freezed.dart';

@Injectable()
class SalesItemAddUseCase
    extends BaseFutureUseCase<SalesItemAddRequest, SalesItemAddOutput> {
  const SalesItemAddUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<SalesItemAddOutput> buildUseCase(SalesItemAddRequest input) async {
    final response = await _repository.salesItemAdd(input);
    final result = responseMapper(response);
    return SalesItemAddOutput(result: result);
  }
}

@freezed
abstract class SalesItemAddOutput extends BaseOutput with _$SalesItemAddOutput {
  const SalesItemAddOutput._();

  const factory SalesItemAddOutput({DomainState<void>? result}) =
      _SalesItemAddOutput;
}
