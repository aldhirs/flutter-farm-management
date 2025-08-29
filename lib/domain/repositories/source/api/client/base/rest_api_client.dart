import 'package:dartx/dartx.dart';
import 'package:dio/dio.dart';
import 'package:farm/constants/server/server_status_code_constants.dart';
import 'package:farm/domain/repositories/mapper/data_response_mapper.dart';
import 'package:farm/domain/entities/model/data_response.dart';
import 'package:farm/utils/typedef.dart';

import '../../exception_mapper/dio_exception_mapper.dart';
import '../../middleware/base_interceptor.dart';
import '../base/api_client_default_settings.dart';
import '../base/dio_builder.dart';

enum RestMethod { get, post, put, patch, delete }

class RestApiClient {
  RestApiClient({
    this.baseUrl = '',
    this.interceptors = const [],
    // this.errorResponseMapperType =
    //     ResponseMapperConstants.defaultErrorResponseMapperType,
    // this.successResponseMapperType =
    //     ResponseMapperConstants.defaultSuccessResponseMapperType,
    // this.connectTimeout = ServerTimeoutConstants.connectTimeout,
    // this.sendTimeout = ServerTimeoutConstants.sendTimeout,
    // this.receiveTimeout = ServerTimeoutConstants.receiveTimeout,
  }) : _dio = DioBuilder.createDio(
         options: BaseOptions(
           baseUrl: baseUrl,
           //  connectTimeout: connectTimeout,
           //  sendTimeout: sendTimeout,
           //  receiveTimeout: receiveTimeout,
         ),
       ) {
    final sortedInterceptors =
        [
          ...ApiClientDefaultSetting.requiredInterceptors(_dio),
          ...interceptors,
        ].sortedByDescending((element) {
          return element is BaseInterceptor ? element.priority : -1;
        });

    _dio.interceptors.addAll(sortedInterceptors);
  }
  final String baseUrl;
  final List<Interceptor> interceptors;
  final Dio _dio;

  Future<DataResponse<D>> request<T, D>({
    required RestMethod method,
    required String path,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Decoder<D>? decoder,
    Map<String, dynamic>? headers,
    String? contentType,
    ResponseType? responseType,
    Duration? sendTimeout,
    Duration? receiveTimeout,
  }) async {
    try {
      final response = await _requestByMethod(
        method: method,
        path: path.startsWith(baseUrl) ? path.substring(baseUrl.length) : path,
        queryParameters: queryParameters,
        body: body,
        options: Options(
          headers: headers,
          contentType: contentType,
          responseType: responseType,
          sendTimeout: sendTimeout,
          receiveTimeout: receiveTimeout,
        ),
      );

      if (response.data != null &&
          response.data['status'] != null &&
          response.data['status'] == false) {
        throw DioException.badResponse(
          statusCode:
              response.data['status'] ?? ServerStatusCodeConstants.failure,
          requestOptions: response.requestOptions,
          response: response,
        );
      }
      return DataResponseMapper<D>().map(response.data, decoder);
    } catch (error) {
      throw DioExceptionMapper().map(error);
    }
  }

  Future<Response<T>> fetch<T>(RequestOptions requestOptions) {
    return _dio.fetch(requestOptions);
  }

  Future<Response> _requestByMethod({
    required RestMethod method,
    required String path,
    Map<String, dynamic>? queryParameters,
    // ignore: avoid-dynamic
    dynamic body,
    Options? options,
  }) {
    switch (method) {
      case RestMethod.get:
        return _dio.get(
          path,
          queryParameters: queryParameters,
          options: options,
        );
      case RestMethod.post:
        return _dio.post(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
        );
      case RestMethod.patch:
        return _dio.patch(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
        );
      case RestMethod.put:
        return _dio.put(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
        );
      case RestMethod.delete:
        return _dio.delete(
          path,
          data: body,
          queryParameters: queryParameters,
          options: options,
        );
    }
  }
}
