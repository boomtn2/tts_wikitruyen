import 'package:tts_wikitruyen/models/chapter_model.dart';
import 'package:tts_wikitruyen/models/models_export.dart';

abstract class IChapterRepository {
  Future<ChapterModel?> getChapter(
      {required ChapterModel chapterModel, String? id});
  Future<int> saveChapter(
      {required ChapterModel chapterModel, required String id});
  Future<int> deleteChapter({required String id});

  Future<List<ChapterModel>?> getListChapters({required String id});
}
