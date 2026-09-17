import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/project/discover_summary.dart';
import 'package:farm/domain/entities/project/discover_summary_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'discover_summary_use_case.freezed.dart';

@Injectable()
class DiscoverSummaryUseCase
    extends BaseFutureUseCase<DiscoverSummaryRequest, DiscoverSummaryOutput> {
  const DiscoverSummaryUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<DiscoverSummaryOutput> buildUseCase(
    DiscoverSummaryRequest input,
  ) async {
    final response = await _repository.discoverSummary(input);
    final result = responseMapper(response);
    return DiscoverSummaryOutput(result: result);
  }
}

@freezed
abstract class DiscoverSummaryOutput extends BaseOutput
    with _$DiscoverSummaryOutput {
  const DiscoverSummaryOutput._();

  const factory DiscoverSummaryOutput({DomainState<DiscoverSummary>? result}) =
      _DiscoverSummaryOutput;
}
