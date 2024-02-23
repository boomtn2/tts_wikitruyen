import 'package:dio/dio.dart';
import '../error_interceptor.dart';
import 'config.dart';

class ServiceGist {
  final dio = Dio(optionGist);

  ServiceGist() {
    dio.interceptors.addAll([
      ErrorInterceptor(),
    ]);
  }
  Future<Response> getHotTag() async {
    try {
      Response response = await dio.get(
          'https://gist.githubusercontent.com/boomtn2/0aa7889d674fb7a84123400a7d76fdc1/raw/');
      return response;
    } catch (e) {
      return Response(
          requestOptions: RequestOptions(),
          statusCode: -1,
          statusMessage: e.toString());
    }
  }

  Future<Response> getCategory() async {
    try {
      Response response = await dio.get(
          'https://gist.githubusercontent.com/boomtn2/cfdad3a9fd937389df699262839a7630/raw/');
      return response;
    } catch (e) {
      return Response(
          requestOptions: RequestOptions(),
          statusCode: -1,
          statusMessage: e.toString());
    }
  }

  Future<Response> getTenMienWikiTruyen() async {
    try {
      Response response = await dio.get(
          'https://gist.githubusercontent.com/boomtn2/b9461e05297f352c4b6a0e3d3d8e7e95/raw/');
      return response;
    } catch (e) {
      return Response(
          requestOptions: RequestOptions(),
          statusCode: -1,
          statusMessage: e.toString());
    }
  }
}
