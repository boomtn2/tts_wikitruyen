import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/models/tag.dart';
import 'package:tts_wikitruyen/services/gist_data/decore_gist.dart';
import 'package:tts_wikitruyen/services/gist_data/strings_link_connection.dart';
import 'package:tts_wikitruyen/services/network/client_netword.dart';
import 'package:tts_wikitruyen/services/network/network_excute.dart';
import 'package:tts_wikitruyen/services/wiki_truyen/decore_wikitruyen.dart';
import 'package:tts_wikitruyen/services/wiki_truyen/path_wiki.dart';
import 'package:dio/dio.dart' as dio;
import '../../models/book.dart';

class SearchPageController extends GetxController {
  SearchPageController() {
    init();
  }
  RxList<Book> listBooks = <Book>[].obs;
  TextEditingController controllerTextSearchName = TextEditingController();
  RxMap listTagSelected = {}.obs;
  RxList<Tag> listTags = <Tag>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;

  Map<String, dynamic> querry = {};
  NetworkExecuter network = NetworkExecuter();
  int start = 0;
  void init() async {
    Client client = Client();
    client.baseURLClient = StringLinkConnection.category;
    var response = await network.excute(router: client);
    if (response is dio.Response) {
      listTags.value = DecoreGist.listTags(response: response);
    } else {
      handleError(error: response);
    }
  }

  void selectTag(
      {required String name, required String param, required String querry}) {
    if (listTagSelected[name] == null) {
      listTagSelected.addAll({
        name: {'param': param, 'querry': querry}
      });
    } else {
      listTagSelected.remove(name);
    }
  }

  WikiBaseClient wiki = WikiBaseClient();
  void loadMoreItems() async {
    isLoadMore.value = true;
    querry['start'] = '${start += 20}';

    wiki.url = PathWiki.search;
    wiki.param = querry;
    var response = await network.excute(router: wiki);

    if (response is dio.Response) {
      listBooks.addAll(DecoreWikiTruyen.getListBook(response: response));
      isLoadMore.value = false;
    }
  }

  void searchName() async {
    if (controllerTextSearchName.value.text.isNotEmpty) {
      wiki.url = PathWiki.search;
      wiki.param = {'qs': 1, 'q': "${controllerTextSearchName.value}"};
      final repo = await network.excute(router: wiki);

      if (repo is dio.Response) {
        listBooks.value = DecoreWikiTruyen.getListBook(response: repo);
      } else {
        handleError(error: repo);
      }
    }
  }

  void handleError({required Object error}) {}

  void searchCategory() async {
    for (var element in listTagSelected.values) {
      String key = element['querry'];
      List<String> listParram = ['${element['param']}'];

      if (querry.isNotEmpty) {
        List<String> temp = querry[key] ?? [];
        if (temp.isNotEmpty) {
          listParram.addAll(temp);
        }
      }
      querry.addAll({key: listParram});
    }
    start = 0;
    querry.addAll({'qs': 1, 'm': 2, 'start': 0, 'so': 4, 'y': 2024});

    wiki.url = PathWiki.search;
    wiki.param = querry;
    var response = await network.excute(router: wiki);

    if (response is dio.Response) {
      listBooks.value = DecoreWikiTruyen.getListBook(response: response);
      isLoadMore.value = false;
    }
  }
}
