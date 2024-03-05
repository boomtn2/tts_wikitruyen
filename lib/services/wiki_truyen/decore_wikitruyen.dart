import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'package:tts_wikitruyen/models/book.dart';

import 'convert_html.dart';

class DecoreWikiTruyen {
  static List<Book> getListBook({required Response response}) {
    List<Book> listBook = ConvertHtml.listBook(response: response);
    return listBook;
  }

  static String getChapter({required Response response, required String link}) {
    return ConvertHtml().getChapter(response: response, link: link);
  }
}
