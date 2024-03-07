import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as parserhtml;
import 'package:html/dom.dart' as dom;

import '../model/book.dart';
import '../model/chapter.dart';

class HTMLHelper {
  List<Book> getListBookHtml(
      {required Response response,
      required String querryList,
      required String queryText,
      required String queryAuthor,
      required String queryview,
      required String queryScr,
      required String queryHref,
      required String domain}) {
    List<Book> listBook = [];
    try {
      if (response.statusCode == 200) {
        dom.Document document = parserhtml.parse(response.data);
        final listBookHTML = document.querySelectorAll(querryList);

        // hạn chế xử dụng class có dấu cách
        for (var element in listBookHTML) {
          listBook.add(getBookHtml(
              element: element,
              queryText: queryText,
              queryAuthor: queryAuthor,
              queryview: queryview,
              queryScr: queryScr,
              queryHref: queryHref,
              domain: domain));
        }
      }
    } catch (e) {
      showLog('[ERROR] getListBookHtml error {$e}');
    }

    return listBook;
  }

  Book getBookHtml(
      {required dom.Element element,
      required String queryText,
      required String queryview,
      required String queryAuthor,
      required String queryScr,
      required String queryHref,
      required String domain}) {
    String title = getTextHTML(element, queryText);
    String view = getTextHTML(element, queryview);
    String tacGia = getTextHTML(element, queryAuthor);
    String img = getScrHTML(element, queryScr);
    String link = getHrefHTML(element, queryHref);

    img = addDomainToLink(img, domain);
    link = addDomainToLink(link, domain);

    final book = Book(
        imgPath: img,
        bookPath: link,
        bookName: title,
        bookAuthor: tacGia,
        bookPublisher: '',
        bookViews: view,
        bookStar: '',
        bookComment: '');
    showLog('[SUCCES] getBookHtml :{${book.toMapFullOption()}}');
    return book;
  }

  Chapter getChapter({
    required Response response,
    required String querryTextChapter,
    required String querryLinkNext,
    required String querryLinkPre,
    required String querryTitle,
    required String linkChapter,
    required String domain,
  }) {
    Chapter chapter = Chapter.none();
    try {
      if (response.statusCode == 200) {
        dom.Document document = parserhtml.parse(response.data);
        final element = document.querySelector('*');
        if (element != null) {
          String textChapter = getTextHTML(element, querryTextChapter);
          String title = getTextHTML(element, querryTitle);
          String linkNext = getHrefHTML(element, querryLinkNext);
          String linkPre = getHrefHTML(element, querryLinkPre);

          linkNext = addDomainToLink(linkNext, domain);
          linkPre = addDomainToLink(linkPre, domain);

          return Chapter(
              text: textChapter,
              title: title,
              linkChapter: linkChapter,
              linkNext: linkNext,
              linkPre: linkPre);
        }
      }
    } catch (e) {
      showLog('[ERROR] getListBookHtml error {$e}');
    }

    return chapter;
  }

  String addDomainToLink(String link, String domain) {
    if (link.startsWith('http')) {
      // Nếu liên kết đã chứa đầy đủ domain, không cần thêm
      return link;
    } else if (link.startsWith('/')) {
      // Nếu liên kết bắt đầu bằng "/", thêm domain vào đầu liên kết
      return domain + link;
    } else {
      // Nếu liên kết không bắt đầu bằng "/", thêm "/" và domain vào đầu liên kết
      return '$domain/$link';
    }
  }

  String getTextHTML(dom.Element element, String query) {
    try {
      final item = element.querySelector(query);

      if (item == null) {
        return '';
      } else {
        return item.text.trim();
      }
    } catch (e) {
      showLog('[ERROR] getTextHTML error {$e}');
      return '';
    }
  }

  String getScrHTML(dom.Element element, String query) {
    try {
      final item = element.querySelector(query);

      if (item == null) {
        return '';
      } else {
        return '${item.attributes['src']}';
      }
    } catch (e) {
      showLog('[ERROR] getScrHTML   {$e}');
      return '';
    }
  }

  String getHrefHTML(dom.Element element, String query) {
    try {
      final item = element.querySelector(query);

      if (item == null) {
        return '';
      } else {
        return '${item.attributes['href']}';
      }
    } catch (e) {
      showLog('[ERROR] getHrefHTML  {$e}');
      return '';
    }
  }

  void showLog(String mess) {
    if (kDebugMode) print("Log html: {$mess}");
  }
}
