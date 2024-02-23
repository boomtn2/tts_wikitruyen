import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/models/tag.dart';
import 'package:tts_wikitruyen/services/gist_data/convert_reponse_gist.dart';
import 'package:tts_wikitruyen/services/gist_data/service_gist.dart';

import '../../models/book.dart';
import '../../services/wiki_truyen/convert_html.dart';
import '../../services/wiki_truyen/service_wikitruyen.dart';

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
  final ServiceWikitruyen _serviceWikitruyen = ServiceWikitruyen();

  Map<String, dynamic> querry = {};

  int start = 0;
  void init() async {
    var response = await ServiceGist().getCategory();

    listTags.value = ConverReponseGist.listTags(response: response);
  }

  void selectTag(
      {required String name, required String param, required String querry}) {
    if (listTagSelected[name] == null) {
      listTagSelected.addAll({
        '$name': {'param': param, 'querry': querry}
      });
    } else {
      listTagSelected.remove(name);
    }
  }

  void loadMoreItems() async {
    isLoadMore.value = true;
    querry['start'] = '${start += 20}';
    var response = await _serviceWikitruyen.search(param: querry);

    listBooks.addAll(ConvertHtml.listBook(response: response));
    isLoadMore.value = false;
  }

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

    var response = await _serviceWikitruyen.search(param: querry);
    listBooks.value = [];
    listBooks.addAll(ConvertHtml.listBook(response: response));
  }
}
