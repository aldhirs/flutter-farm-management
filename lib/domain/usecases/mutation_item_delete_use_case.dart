import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/mutation/mutation_item_delete_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/domain/usecases/mutation_item_add_use_case.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class MutationItemDeleteUseCase
    extends
        BaseFutureUseCase<MutationItemDeleteRequest, MutationItemVoidOutput> {
  const MutationItemDeleteUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<MutationItemVoidOutput> buildUseCase(
    MutationItemDeleteRequest input,
  ) async {
    final response = await _repository.mutationItemDelete(input);
    final result = responseMapper(response);
    return MutationItemVoidOutput(result: result);
  }
}
