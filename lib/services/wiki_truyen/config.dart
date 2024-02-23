import 'package:dio/dio.dart';

final String BASE_URL = "https://wikisach.net/";
final options = BaseOptions(
  baseUrl: BASE_URL,
  connectTimeout: Duration(seconds: 30),
  receiveTimeout: Duration(seconds: 30),
  validateStatus: (int? status) {
    return status != null;
    // return status != null && status >= 200 && status < 300;
  },
);
