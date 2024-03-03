import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:tts_wikitruyen/models/book.dart';
import 'package:tts_wikitruyen/models/bookinfor.dart';
import 'package:tts_wikitruyen/services/network/client_netword.dart';
import 'package:tts_wikitruyen/services/wiki_truyen/path_wiki.dart';

import 'convert_html.dart';

class DecoreWikiTruyen {
  static List<Book> getListBook({required Response response}) {
    List<Book> listBook = ConvertHtml.listBook(response: response);
    return listBook;
  }

  static String getChapter({required Response response, required String link}) {
    return ConvertHtml().getChapter(response: response, link: link);
  }

  static BookInfo getInfoBook({required Response response}) {
    //danh sach chuong

    BookInfo info = ConvertHtml.getBook(response: response);

    return info;
  }

  static Future<WikiBaseClient> getKeyChapters(
      {required Response reponseBookInfoNow}) async {
    String funcJS = ConvertHtml.extractFuzzySign(reponseBookInfoNow.data) ?? '';
    String bookId = ConvertHtml.extractIdBook(reponseBookInfoNow.data) ?? '';
    String signKey = ConvertHtml.extractSignKey(reponseBookInfoNow.data) ?? '';
    //key sign

    String sign = await jsCreateKey(fuzzySign: funcJS, signKey: signKey);

    final wiki = WikiBaseClient()
      ..url = PathWiki.listChapters
      ..param = {
        'bookId': bookId,
        'start': 0,
        'size': 501,
        'signKey': signKey,
        'sign': sign
      };

    return wiki;
  }

  static getListChapter({required Response response}) {
    return ConvertHtml.getListChapter(response: response);
  }

  static Future<String> jsCreateKey(
      {required String fuzzySign,
      required String signKey,
      String start = '0',
      String size = '501'}) async {
    String pathJS = await rootBundle.loadString('assets/js/js_wikitruyen.js');
    final JavascriptRuntime javascriptRuntime =
        getJavascriptRuntime(forceJavascriptCoreOnAndroid: false);

    String key = signKey + start + size;
    JsEvalResult jsEvalResult =
        javascriptRuntime.evaluate("""$fuzzySign fuzzySign('$key')""");

    String keyFuzzySign = jsEvalResult.stringResult;

    //key sign
    jsEvalResult =
        javascriptRuntime.evaluate("""${pathJS}a('$keyFuzzySign')""");
    return jsEvalResult.stringResult;
  }
}
