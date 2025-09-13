import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/supplier/supplier.dart';
import 'package:farm/domain/entities/supplier/supplier_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'suppliers_use_case.freezed.dart';

@Injectable()
class SuppliersUseCase
    extends BaseFutureUseCase<SupplierRequest, SuppliersOutput> {
  const SuppliersUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<SuppliersOutput> buildUseCase(SupplierRequest input) async {
    final response = await _repository.suppliers(input);
    final result = responseListMapper(response);
    return SuppliersOutput(result: result);
  }
}

@freezed
abstract class SuppliersOutput extends BaseOutput with _$SuppliersOutput {
  const SuppliersOutput._();

  const factory SuppliersOutput({DomainState<List<Supplier>>? result}) =
      _SuppliersOutput;
}
