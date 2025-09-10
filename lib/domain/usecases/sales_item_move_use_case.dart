import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/sales/sales_item_move_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sales_item_move_use_case.freezed.dart';

@Injectable()
class SalesItemMoveUseCase
    extends BaseFutureUseCase<SalesItemMoveRequest, SalesItemMoveOutput> {
  const SalesItemMoveUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<SalesItemMoveOutput> buildUseCase(SalesItemMoveRequest input) async {
    final response = await _repository.salesItemMove(input);
    final result = responseMapper(response);
    return SalesItemMoveOutput(result: result);
  }
}

@freezed
abstract class SalesItemMoveOutput extends BaseOutput
    with _$SalesItemMoveOutput {
  const SalesItemMoveOutput._();

  const factory SalesItemMoveOutput({DomainState<void>? result}) =
      _SalesItemMoveOutput;
}
