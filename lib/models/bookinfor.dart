import 'package:tts_wikitruyen/models/book.dart';

class BookInfo {
  Book? book;
  List<Map<String, String>> theLoai;
  String moTa;
  List<Map<String, String>> dsChuong;

  BookInfo({
    this.book = null,
    required this.theLoai,
    required this.moTa,
    required this.dsChuong,
  });

  toMap() {
    return '{theLoai: $theLoai, moTa: $moTa, dsChuong: $dsChuong}';
  }
}
