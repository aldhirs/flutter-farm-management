import 'package:farm/utils/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../entities/model/data_response.dart';

@Injectable()
class DataResponseMapper<T> {
  DataResponse<T> map(dynamic response, Decoder<T>? decoder) {
    return decoder != null && response is Map<String, dynamic>
        ? DataResponse.fromJson(response, (json) => decoder(json))
        : DataResponse<T>(data: response);
  }
}
