import 'package:farm/domain/entities/model/data_response.dart';
import 'package:farm/extensions/bool.dart';
import 'package:farm/utils/domain_state.dart';

DomainState<T> responseMapper<T>(DataResponse<T> response) {
  if (response.status?.defaultFalse() == true) {
    return DomainState.success(response.data as T, response.message);
  } else {
    return DomainState.error(response.message);
  }
}

DomainState<List<T>> responseListMapper<T>(DataListResponse<T> response) {
  if (response.status?.defaultFalse() == true) {
    return DomainState.success(response.data ?? <T>[], response.message);
  } else {
    return DomainState.error(response.message);
  }
}
