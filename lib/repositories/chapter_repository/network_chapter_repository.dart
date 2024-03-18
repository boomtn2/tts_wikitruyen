import 'package:tts_wikitruyen/models/chapter_model.dart';
import 'package:tts_wikitruyen/repositories/chapter_repository/i_chapter_repository.dart';
import 'package:tts_wikitruyen/repositories/website_repository/i_website_repository.dart';
import 'package:tts_wikitruyen/repositories/website_repository/website_repository.dart';
import 'package:tts_wikitruyen/services/html/html.dart';

import 'package:tts_wikitruyen/services/network/network.dart';
import 'package:dio/dio.dart' as dio;

class NetWorkChapterRepository implements IChapterRepository {
  final NetworkExecuter _network = NetworkExecuter();
  final Client _client = Client();
  final IWebsiteRepository _websiteRepository = WebsiteRepository();
  final HTMLHelper _htmlHelper = HTMLHelper();

  @override
  Future<int> deleteChapter({required String id}) async {
    return 0;
  }

  @override
  Future<int> saveChapter(
      {required ChapterModel chapterModel, required String id}) async {
    return 0;
  }

  @override
  Future<ChapterModel?> getChapter(
      {required ChapterModel chapterModel, String? id}) async {
    _client.baseURLClient = chapterModel.linkChapter;
    final repo = await _network.excute(router: _client);
    final website = await _websiteRepository.findWebsite(link: _client.baseURL);

    if (repo is dio.Response) {
      if (repo.statusCode == 200) {
        if (website != null) {
          return _htmlHelper.getChapter(
              response: repo,
              querryTextChapter: website.chapterhtml.querryTextChapter,
              querryLinkNext: website.chapterhtml.querryLinkNext,
              querryLinkPre: website.chapterhtml.querryLinkPre,
              querryTitle: website.chapterhtml.querryTitle,
              linkChapter: chapterModel.linkChapter,
              domain: website.chapterhtml.domain);
        }
      }
    }
    return null;
  }

  @override
  Future<List<ChapterModel>?> getListChapters({required String id}) async {
    return null;
  }
}
