import 'package:farm/domain/entities/model/data_response.dart';
import 'package:farm/domain/repositories/mapper/base/base_success_response_mapper.dart';
import 'package:farm/utils/typedef.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class DataJsonObjectResponseMapper<T>
    extends BaseSuccessResponseMapper<T, DataResponse<T>> {
  @override
  // ignore: avoid-dynamic
  DataResponse<T> map(dynamic response, Decoder<T>? decoder) {
    return decoder != null && response is Map<String, dynamic>
        ? DataResponse.fromJson(response, (json) => decoder(json))
        : DataResponse<T>(data: response);
  }
}
