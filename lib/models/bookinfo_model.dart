import 'book_model.dart';

class BookInfoModel {
  BookModel? book;
  Map<String, String> theLoai;
  String moTa;
  Map<String, String> dsChuong;

  BookInfoModel({
    this.book,
    required this.theLoai,
    required this.moTa,
    required this.dsChuong,
  });
  BookInfoModel.none({
    this.book,
    this.theLoai = const {},
    this.moTa = '',
    this.dsChuong = const {},
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
