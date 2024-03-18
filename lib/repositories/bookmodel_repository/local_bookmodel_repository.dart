import 'package:tts_wikitruyen/repositories/bookmodel_repository/i_bookmodel_repository.dart';
import 'package:tts_wikitruyen/services/local/local.dart';

import '../../models/models_export.dart';

class LocalBookModelRepository implements IBookModelReporitory {
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Future<int> addBookModel(
      {required TableOption tableOption,
      required BookModel bookModel,
      BookInfoModel? bookInfoModel,
      String? link}) async {
    switch (tableOption) {
      case TableOption.favorit:
        return databaseHelper.insertBookFavorite(book: bookModel);
      case TableOption.offline:
        if (bookInfoModel != null) {
          return databaseHelper.insertBookOffline(
              book: bookModel, item: bookInfoModel);
        } else {
          return 0;
        }
      case TableOption.history:
        if (bookModel.history != null) {
          await databaseHelper.deleteHistory(bookModel.id);
          await databaseHelper.deleteBookHistory(bookModel.id);
          await databaseHelper.insertBookHistory(book: bookModel);
          return databaseHelper.insertHistory(
              id: bookModel.id,
              nameChapter: bookModel.history!.nameChapter,
              text: bookModel.history!.text,
              linkChapter: bookModel.history!.chapterPath);
        } else {
          return 0;
        }

      default:
        return 0;
    }
  }

  Future<bool> isFavorite(BookModel bookModel) async {
    final repo = await databaseHelper.isFavorite(bookModel.id);
    if (repo != 0) {
      return true;
    }
    return false;
  }

  @override
  Future<int> deleteBookModel(
      {required TableOption tableOption,
      required BookModel bookModel,
      String? link}) async {
    switch (tableOption) {
      case TableOption.favorit:
        return databaseHelper.deleteBookFavorite(bookModel.id);
      case TableOption.offline:
        return databaseHelper.deleteBookOffline(bookModel.id);
      case TableOption.history:
        return databaseHelper.deleteAllBookHistory();
      default:
        return 0;
    }
  }

  @override
  Future<List<BookModel>?> getListBookModel(
      {required TableOption tableOption, String? link}) async {
    switch (tableOption) {
      case TableOption.favorit:
        return databaseHelper.getListBookFavorite();
      case TableOption.offline:
        return databaseHelper.getListBookOffline();
      case TableOption.history:
        return databaseHelper.getListBookHistory();
      default:
        return null;
    }
  }
}
