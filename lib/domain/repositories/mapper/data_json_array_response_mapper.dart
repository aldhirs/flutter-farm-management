import 'package:farm/domain/entities/model/data_response.dart';
import 'package:farm/domain/repositories/mapper/base/base_success_response_mapper.dart';
import 'package:farm/utils/typedef.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class DataJsonArrayResponseMapper<T>
    extends BaseSuccessResponseMapper<T, DataListResponse<T>> {
  @override
  // ignore: avoid-dynamic
  DataListResponse<T> map(dynamic response, Decoder<T>? decoder) {
    return decoder != null && response is Map<String, dynamic>
        ? DataListResponse.fromJson(response, (json) => decoder(json))
        : DataListResponse<T>(data: response);
  }
}
