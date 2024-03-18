import '../../models/models_export.dart';

abstract class IBookInforRepository {
  Future<BookInfoModel> getBookInfo(BookModel? book,
      {required String idOrLink});
}
