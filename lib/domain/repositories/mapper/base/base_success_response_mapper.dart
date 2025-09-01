import 'package:farm/constants/enum_constants.dart';
import 'package:farm/domain/repositories/mapper/data_json_array_response_mapper.dart';
import 'package:farm/domain/repositories/mapper/data_json_object_reponse_mapper.dart';
import 'package:farm/utils/typedef.dart';

abstract class BaseSuccessResponseMapper<I, O> {
  const BaseSuccessResponseMapper();

  factory BaseSuccessResponseMapper.fromType(SuccessResponseMapperType type) {
    switch (type) {
      case SuccessResponseMapperType.dataJsonObject:
        return DataJsonObjectResponseMapper<I>()
            as BaseSuccessResponseMapper<I, O>;
      case SuccessResponseMapperType.dataJsonArray:
        return DataJsonArrayResponseMapper<I>()
            as BaseSuccessResponseMapper<I, O>;
    }
  }

  // ignore: avoid-dynamic
  O map(dynamic response, Decoder<I>? decoder);
}
