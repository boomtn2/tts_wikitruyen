import 'dart:convert';

import 'package:tts_wikitruyen/repositories/bookmodel_repository/i_bookmodel_repository.dart';
import 'package:tts_wikitruyen/repositories/website_repository/i_website_repository.dart';
import 'package:tts_wikitruyen/repositories/website_repository/website_repository.dart';
import 'package:tts_wikitruyen/services/html/html.dart';
import 'package:tts_wikitruyen/services/network/network.dart';
import 'package:dio/dio.dart' as dio;

import '../../models/models_export.dart';

class NetWorkBookModelRepository implements IBookModelReporitory {
  NetworkExecuter network = NetworkExecuter();
  Client client = Client();
  IWebsiteRepository websiteRepository = WebsiteRepository();
  HTMLHelper htmlHelper = HTMLHelper();
  @override
  Future<int> deleteBookModel(
      {required TableOption tableOption,
      required BookModel bookModel,
      String? link}) {
    throw UnimplementedError();
  }

  @override
  Future<List<BookModel>?> getListBookModel(
      {required TableOption tableOption, String? link}) async {
    if (link != null) {
      client.baseURLClient = link;

      final repo = await network.excute(router: client);

      if (repo is dio.Response) {
        if (repo.statusCode == 200) {
          if (tableOption == TableOption.youtube) {
            return _getBookInforYoutube(repo);
          }
          Website? website = await websiteRepository.findWebsite(link: link);

          if (website != null) {
            final querry = website.listbookhtml;
            return htmlHelper.getListBookHtml(
                response: repo,
                querryList: querry.querryList,
                queryText: querry.queryText,
                queryAuthor: querry.queryAuthor,
                queryview: querry.queryview,
                queryScr: querry.queryScr,
                queryHref: querry.queryHref,
                domain: querry.domain);
          }
        }
      }
    }

    return null;
  }

  List<BookModel> _getBookInforYoutube(dio.Response response) {
    List<BookModel> lis = [];
    try {
      List json = jsonDecode(response.data) as List;

      for (var element in json) {
        BookModel book = BookModel.json(element);
        HistoryModel history = HistoryModel.json(element);
        book.history = history;
        lis.add(book);
      }

      return lis;
    } catch (e) {
      return lis;
    }
  }

  @override
  Future<int> addBookModel(
      {required TableOption tableOption,
      required BookModel bookModel,
      BookInfoModel? bookInfoModel,
      String? link}) {
    // TODO: implement addBookModel
    throw UnimplementedError();
  }
}
