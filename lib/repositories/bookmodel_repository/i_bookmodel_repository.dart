import 'package:tts_wikitruyen/models/book_model.dart';
import 'package:tts_wikitruyen/models/bookinfo_model.dart';

enum TableOption { home, youtube, history, favorit, offline, search, booksame }

abstract class IBookModelReporitory {
  Future<List<BookModel>?> getListBookModel(
      {required TableOption tableOption, String? link});

  Future<int> deleteBookModel(
      {required TableOption tableOption,
      required BookModel bookModel,
      String? link});

  Future<int> addBookModel(
      {required TableOption tableOption,
      required BookModel bookModel,
      BookInfoModel? bookInfoModel,
      String? link});
}
