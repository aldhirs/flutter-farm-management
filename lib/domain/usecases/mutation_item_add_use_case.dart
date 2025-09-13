import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/mutation/mutation_item_add_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'mutation_item_add_use_case.freezed.dart';

@Injectable()
class MutationItemAddUseCase
    extends BaseFutureUseCase<MutationItemAddRequest, MutationItemVoidOutput> {
  const MutationItemAddUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<MutationItemVoidOutput> buildUseCase(
    MutationItemAddRequest input,
  ) async {
    final response = await _repository.mutationItemAdd(input);
    final result = responseMapper(response);
    return MutationItemVoidOutput(result: result);
  }
}

@freezed
abstract class MutationItemVoidOutput extends BaseOutput
    with _$MutationItemVoidOutput {
  const MutationItemVoidOutput._();

  const factory MutationItemVoidOutput({DomainState<void>? result}) =
      _MutationItemVoidOutput;
}
