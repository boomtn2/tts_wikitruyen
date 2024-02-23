import 'package:tts_wikitruyen/services/wiki_truyen/config.dart';

//master 2
class Book {
  String imgPath;
  String bookPath;
  String bookName;
  String bookAuthor;
  String bookPublisher;
  String bookViews;
  String bookStar;
  String bookComment;
  History? history;
  Book(
      {required this.imgPath,
      required this.bookPath,
      required this.bookName,
      required this.bookAuthor,
      required this.bookPublisher,
      required this.bookViews,
      required this.bookStar,
      required this.bookComment});

  String get imgFullPath => BASE_URL + imgPath;
  String get bookFullPath => BASE_URL + bookPath;

  Map<String, dynamic> toMap() {
    return {
      'imgPath': imgPath,
      'bookPath': bookPath,
      'bookName': bookName,
      'bookAuthor': bookAuthor,
      'bookPublisher': bookPublisher,
      'bookViews': bookViews,
      'bookStar': bookStar,
      'bookComment': bookComment,
    };
  }

  Map<String, dynamic> toMapFullOption() {
    return {
      'imgPath': imgPath,
      'bookPath': bookPath,
      'bookName': bookName,
      'bookAuthor': bookAuthor,
      'bookPublisher': bookPublisher,
      'bookViews': bookViews,
      'bookStar': bookStar,
      'bookComment': bookComment,
      'history': history?.toMap(),
    };
  }
}

class History {
  String nameChapter;
  String chapterPath;
  String text;

  History(
      {required this.nameChapter,
      required this.chapterPath,
      required this.text});
  Map<String, dynamic> toMap() {
    return {
      'nameChapter': nameChapter,
      'chapterPath': chapterPath,
      'text': text,
    };
  }
}
