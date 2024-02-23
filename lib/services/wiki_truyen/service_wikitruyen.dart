import 'package:dio/dio.dart';

import 'package:tts_wikitruyen/services/wiki_truyen/config.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as dom;

import '../error_interceptor.dart';

class ServiceWikitruyen {
  final dio = Dio(options);
  ServiceWikitruyen() {
    dio.interceptors.addAll([
      ErrorInterceptor(),
    ]);
  }
  Future<Response> search({required Map<String, dynamic> param}) async {
    try {
      Response response = await dio.get('/tim-kiem', queryParameters: param);
      return response;
    } catch (e) {
      return Response(requestOptions: RequestOptions(), statusCode: -1);
    }
  }

  Future<Response> request({required String path}) async {
    try {
      Response response = await dio.get(path);
      return response;
    } catch (e) {
      return Response(requestOptions: RequestOptions(), statusCode: -1);
    }
  }

  Future<Response> loadChapter(
      {required String bookId,
      String start = '0',
      String size = '501',
      required String signKey,
      required String sign}) async {
    try {
      Response response = await dio.get('/book/index', queryParameters: {
        'bookId': bookId,
        'start': start,
        'size': size,
        'signKey': signKey,
        'sign': sign
      });
      return response;
    } catch (e) {
      return Response(requestOptions: RequestOptions(), statusCode: -1);
    }
  }
}
