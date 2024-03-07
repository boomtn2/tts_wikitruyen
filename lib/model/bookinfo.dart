import 'book.dart';

class BookInfo {
  Book? book;
  Map<String, String> theLoai;
  String moTa;
  Map<String, String> dsChuong;

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
      if (dsChuong.containsKey(choose.entries.first.key)) {
        return i;
      }
    }
    return 0;
  }
}
