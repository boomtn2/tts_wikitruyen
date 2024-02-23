import 'package:dio/dio.dart';

final optionGist = BaseOptions(
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    validateStatus: (int? status) {
      return status != null;
      // return status != null && status >= 200 && status < 300;
    });
