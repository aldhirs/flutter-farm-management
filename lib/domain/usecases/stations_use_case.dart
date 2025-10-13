import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/station/station.dart';
import 'package:farm/domain/entities/station/station_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'stations_use_case.freezed.dart';

@Injectable()
class StationsUseCase
    extends BaseFutureUseCase<StationRequest, StationsOutput> {
  const StationsUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<StationsOutput> buildUseCase(StationRequest input) async {
    final response = await _repository.stations(input);
    final result = responseListMapper(response);
    return StationsOutput(result: result);
  }
}

@freezed
abstract class StationsOutput extends BaseOutput with _$StationsOutput {
  const StationsOutput._();

  const factory StationsOutput({DomainState<List<Station>>? result}) =
      _StationsOutput;
}
