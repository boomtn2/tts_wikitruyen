import 'package:dio/dio.dart';
import 'package:tts_wikitruyen/services/wiki_truyen/config.dart';

import '../../models/book.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as dom;

import '../../models/bookinfor.dart';

class ConvertHtml {
  static List<Book> listBook({required Response response}) {
    List<Book> listBook = [];
    try {
      if (response.statusCode == 200) {
        String htmlString = response.data;
        // Phân tích cú pháp HTML
        dom.Document document = htmlParser.parse(htmlString);
        var bookItems = document.querySelectorAll('div.book-item');

        // In ra nội dung của mỗi thẻ div có class là "book-item"
        for (var item in bookItems) {
          //lay link
          String img = '';
          var temp = item.querySelector('img');
          if (temp != null) {
            img = temp.attributes['src'] ?? '';
          }

          String bookAuthor = '';
          temp = item.querySelector('p.book-author');
          if (temp != null) {
            bookAuthor = temp.text;
          }

          String bookName = '';
          String bookPath = '';
          temp = item.querySelector('a.tooltipped');
          if (temp != null) {
            bookName = temp.attributes['data-tooltip'] ?? '';
            bookPath += temp.attributes['href'] ?? '';
          }

          String bookPublisher = '';
          temp = item.querySelector('p.book-publisher');
          if (temp != null) {
            bookPublisher = temp.text;
          }

          String bookViews = '';
          String bookComment = '';
          String bookStar = '';
          var listItem = item.querySelectorAll('span.book-stats');
          listItem.forEach((element) {
            String text = element.text;
            if (text.contains('visibility')) {
              bookViews = text.replaceAll('visibility', '');
            } else if (text.contains('star')) {
              bookStar = text.replaceAll('star', '');
            } else {
              bookComment = text;
            }
          });

          listBook.add(Book(
              imgPath: img,
              bookAuthor: bookAuthor,
              bookName: bookName,
              bookPath: bookPath,
              bookPublisher: bookPublisher,
              bookViews: bookViews,
              bookComment: bookComment,
              bookStar: bookStar));
        }
      } else {}
    } catch (e) {
      print("lõi${e}");
    }
    return listBook;
  }

  static BookInfo getBook({required Response response}) {
    String moTa = '';
    List<Map<String, String>> theLoai = [];
    if (response.statusCode == 200) {
      String htmlString = response.data;

      // Phân tích cú pháp HTML
      dom.Document document = htmlParser.parse(htmlString);
      var info = document.querySelector('div.book-desc');

      // In ra nội dung của mỗi thẻ div có class là "book-item"

      //lay link

      if (info != null) {
        var temp = info.querySelector('div.book-desc-detail');
        if (temp != null) {
          moTa = temp.text;
        }

        info.querySelectorAll('a').forEach((element) {
          theLoai.add({element.text: element.attributes['href'] ?? ''});
        });
      }
    }
    return BookInfo(theLoai: theLoai, moTa: moTa, dsChuong: []);
  }

  static String getChapter({required Response response}) {
    String chapter = '';

    if (response.statusCode == 200) {
      String htmlString = response.data;

      // Phân tích cú pháp HTML
      dom.Document document = htmlParser.parse(htmlString);
      var info = document.querySelector('#bookContentBody');

      // In ra nội dung của mỗi thẻ div có class là "book-item"

      //lay link

      if (info != null) {
        chapter = info.text;
      }
    }
    return chapter;
  }

  static List<Map<String, String>> getListChapter(
      {required Response response}) {
    List<Map<String, String>> listChapter = [];
    if (response.statusCode == 200) {
      String htmlString = response.data;

      // Phân tích cú pháp HTML
      dom.Document document = htmlParser.parse(htmlString);
      document.querySelectorAll('a.truncate').forEach((element) {
        listChapter.add({element.text: element.attributes['href'] ?? ''});
      });
    }

    return listChapter;
  }

  static String? extractSignKey(String html) {
    RegExp regex = RegExp(r'signKey\s*=\s*"(.*?)";');
    Match? match = regex.firstMatch(html);
    return match?.group(1);
  }

  static String? extractIdBook(String html) {
    RegExp regex = RegExp(r'bookId\s*=\s*"(.*?)";');
    Match? match = regex.firstMatch(html);
    return match?.group(1);
  }

  static String? extractFuzzySign(String html) {
    RegExp regex = RegExp(r'function fuzzySign[\s\S]*?}');
    Match? match = regex.firstMatch(html);
    return match?.group(0);
  }
}
