import 'package:tts_wikitruyen/models/bookinfo_model.dart';
import 'package:tts_wikitruyen/repositories/bookinfo_repository/i_bookinfor_repository.dart';
import 'package:tts_wikitruyen/services/local/local.dart';

import '../../models/book_model.dart';

class LocalBookinforRepository implements IBookInforRepository {
  final DatabaseHelper _sqlite = DatabaseHelper();
  @override
  Future<BookInfoModel> getBookInfo(BookModel? book,
      {required String idOrLink}) async {
    BookInfoModel bookInfoModel = BookInfoModel.none();
    if (book != null) {
      bookInfoModel = await _sqlite.getBookInfoOffline(book: book);
    }
    return bookInfoModel;
  }
}
