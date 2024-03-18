import 'history_model.dart';

class BookModel {
  String imgPath;
  String bookPath;
  String bookName;
  String bookAuthor;
  String bookPublisher;
  String bookViews;
  String bookStar;
  String bookComment;
  HistoryModel? history;

  BookModel(
      {required this.imgPath,
      required this.bookPath,
      required this.bookName,
      required this.bookAuthor,
      required this.bookPublisher,
      required this.bookViews,
      required this.bookStar,
      required this.bookComment,
      this.history});

  String get id => bookName + bookAuthor;
  factory BookModel.json(Map<dynamic, dynamic> json) {
    return BookModel(
        imgPath: '${json['imgPath']}',
        bookPath: '${json['bookPath']}',
        bookName: '${json['bookName']}',
        bookAuthor: '${json['bookAuthor']}',
        bookPublisher: '${json['bookPublisher']}',
        bookViews: '${json['bookPublisher']}',
        bookStar: '${json['bookPublisher']}',
        bookComment: '${json['bookPublisher']}',
        history: json['history'] == null
            ? null
            : HistoryModel.json(json['history']));
  }

  factory BookModel.none() {
    return BookModel(
        imgPath: '',
        bookPath: '',
        bookName: '',
        bookAuthor: '',
        bookPublisher: '',
        bookViews: '',
        bookStar: '',
        bookComment: '',
        history: null);
  }
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
