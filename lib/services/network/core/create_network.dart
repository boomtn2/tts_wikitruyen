import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../client_netword.dart';
import 'error_interceptor.dart';
import '../untils/untils.dart';

class NetworkCreate {
  final Dio _client = Dio();
  Future<Object> request({required BaseClientGenerator route}) async {
    _client.interceptors.add(ErrorInterceptor());
    try {
      Response reponse = await _client.fetch(RequestOptions(
        baseUrl: route.baseURL,
        method: route.method,
        path: route.path,
        queryParameters: route.queryParameters,
        //data: route.body,
        validateStatus: (int? status) {
          return status != null;
        },
        // sendTimeout: Duration(milliseconds: route.sendTimeout),
        receiveTimeout: Duration(milliseconds: route.sendTimeout),
      ));
      return reponse;
    } on DioException catch (e) {
      if (kDebugMode) print('${e.type}: {${e.requestOptions.uri}}');

      return _handleError(e);
    } catch (e) {
      return ErrorNetWork(
          code: ResponseCode.NOT_FOUND, message: '$e', description: '$e');
    }
  }

  void close() {
    _client.close();
  }

  Future<ErrorNetWork> _handleError(DioException exception) async {
    late ErrorNetWork error;

    switch (exception.type) {
      case DioExceptionType.badResponse:
        error = ErrorNetWork(
            code: ResponseCode.BAD_REQUEST,
            message: AppStringNetWork.bad_request_error,
            description:
                messageErrorNetWork[AppStringNetWork.bad_request_error] ??
                    'badResponse');
        break;
      case DioExceptionType.badCertificate:
        error = ErrorNetWork(
            code: ResponseCode.BadCertificate,
            message: AppStringNetWork.bad_certificate,
            description:
                messageErrorNetWork[AppStringNetWork.bad_certificate] ??
                    'badCertificate');
        break;
      case DioExceptionType.cancel:
        error = ErrorNetWork(
            code: ResponseCode.CANCEL,
            message: 'Cancel',
            description: 'Cancel');
        break;
      case DioExceptionType.connectionError:
        error = ErrorNetWork(
            code: ResponseCode.DEFAULT,
            message: AppStringNetWork.connection_error,
            description:
                messageErrorNetWork[AppStringNetWork.connection_error] ??
                    'connectionError');
        break;
      case DioExceptionType.connectionTimeout:
        error = ErrorNetWork(
            code: ResponseCode.CONNECT_TIMEOUT,
            message: AppStringNetWork.timeout_error,
            description: messageErrorNetWork[AppStringNetWork.timeout_error] ??
                'connectionTimeout');
        break;
      case DioExceptionType.sendTimeout:
        error = ErrorNetWork(
            code: ResponseCode.SEND_TIMEOUT,
            message: AppStringNetWork.timeout_error,
            description: messageErrorNetWork[AppStringNetWork.timeout_error] ??
                'sendTimeout');
        break;
      case DioExceptionType.unknown:
        error = ErrorNetWork(
            code: ResponseCode.DEFAULT,
            message: 'unknown',
            description: 'unknow');
        break;
      case DioExceptionType.receiveTimeout:
        error = ErrorNetWork(
            code: ResponseCode.RECIEVE_TIMEOUT,
            message: AppStringNetWork.timeout_error,
            description: messageErrorNetWork[AppStringNetWork.timeout_error] ??
                'receiveTimeout');
        break;
    }

    return error;
  }
}
