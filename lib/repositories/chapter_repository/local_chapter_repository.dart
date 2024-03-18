import 'package:tts_wikitruyen/models/book_model.dart';
import 'package:tts_wikitruyen/models/chapter_model.dart';
import 'package:tts_wikitruyen/repositories/chapter_repository/i_chapter_repository.dart';

import '../../services/local/local.dart';

class LocalChapterRepository implements IChapterRepository {
  final DatabaseHelper _sqlite = DatabaseHelper();
  @override
  Future<int> deleteChapter({required String id}) {
    return _sqlite.deleteChapter(id);
  }

  @override
  Future<int> saveChapter(
      {required ChapterModel chapterModel, required String id}) {
    return _sqlite.insertChapter(
        id: id,
        nameChapter: chapterModel.title,
        text: chapterModel.text,
        linkChapter: chapterModel.linkChapter);
  }

  @override
  Future<ChapterModel?> getChapter(
      {required ChapterModel chapterModel, String? id}) async {
    chapterModel.text = await _sqlite.getTextChapterOffline(
        id: id ?? '', nChapter: chapterModel.linkChapter);
    return chapterModel;
  }

  Future<Map<String, String>> listNameChapters(BookModel book) async {
    final data = await _sqlite.getBookInfoOffline(book: book);

    return data.dsChuong;
  }

  @override
  Future<List<ChapterModel>?> getListChapters({required String id}) async {
    return null;
  }
}
