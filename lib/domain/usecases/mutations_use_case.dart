import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/mutation/mutation.dart';
import 'package:farm/domain/entities/mutation/mutation_request.dart';
import 'package:farm/domain/entities/sales/sales_request.dart';
import 'package:farm/domain/entities/sales/sales.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'mutations_use_case.freezed.dart';

@Injectable()
class MutationsUseCase
    extends BaseFutureUseCase<MutationRequest, MutationsOutput> {
  const MutationsUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<MutationsOutput> buildUseCase(MutationRequest input) async {
    final response = await _repository.mutations(input);
    final result = responseListMapper(response);
    return MutationsOutput(
      result: result,
      total_page: response.total_page,
      page: response.page,
    );
  }
}

@freezed
abstract class MutationsOutput extends BaseOutput with _$MutationsOutput {
  const MutationsOutput._();

  const factory MutationsOutput({
    DomainState<List<Mutation>>? result,
    int? total_page,
    int? page,
  }) = _MutationsOutput;
}
