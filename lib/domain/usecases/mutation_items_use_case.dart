import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/mutation/mutation_item.dart';
import 'package:farm/domain/entities/mutation/mutation_item_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'mutation_items_use_case.freezed.dart';

@Injectable()
class MutationItemsUseCase
    extends BaseFutureUseCase<MutationItemRequest, MutationItemsOutput> {
  const MutationItemsUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<MutationItemsOutput> buildUseCase(MutationItemRequest input) async {
    final response = await _repository.mutationItems(input);
    final result = responseListMapper(response);
    return MutationItemsOutput(
      result: result,
      total_page: response.total_page,
      page: response.page,
    );
  }
}

@freezed
abstract class MutationItemsOutput extends BaseOutput
    with _$MutationItemsOutput {
  const MutationItemsOutput._();

  const factory MutationItemsOutput({
    DomainState<List<MutationItem>>? result,
    int? total_page,
    int? page,
  }) = _MutationItemsOutput;
}
