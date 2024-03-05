import 'package:tts_wikitruyen/models/book.dart';

class BookInfo {
  Book? book;
  List<Map<String, String>> theLoai;
  String moTa;
  List<Map<String, String>> dsChuong;

  BookInfo({
    this.book,
    required this.theLoai,
    required this.moTa,
    required this.dsChuong,
  });

  toMap() {
    return '{theLoai: $theLoai, moTa: $moTa, dsChuong: $dsChuong}';
  }

  int getIndexChapterInList({required Map<String, String> choose}) {
    for (int i = 0; i < dsChuong.length; ++i) {
      if (dsChuong[i].entries.first.key == choose.entries.first.key &&
          dsChuong[i].entries.first.value == choose.entries.first.value) {
        return i;
      }
    }
    return 0;
  }

  List<String> getListLinks() {
    List<String> links = [];
    for (var element in dsChuong) {
      links.add(element.entries.first.value);
    }
    return links;
  }
}
