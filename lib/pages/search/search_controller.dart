import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/html/html.dart';

import 'package:tts_wikitruyen/services/local/hive/hive_service.dart';

import '../../model/model.dart';
import '../../services/network/network.dart';
import 'package:dio/dio.dart' as dio;

class SearchPageController extends GetxController {
  SearchPageController() {
    init();
  }
  RxList<Book> listBooks = <Book>[].obs;
  TextEditingController controllerTextSearchName = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  bool isEnd = false;

  RxList<GroupTagSearch> listGrTagSearch = <GroupTagSearch>[].obs;
  RxList<TagSearch> selectedTag = <TagSearch>[].obs;

  NetworkExecuter network = NetworkExecuter();
  Client client = Client();
  ListWebsite _listWebsite = ListWebsite.none();
  Rx<Website> websiteNow = Website.none().obs;
  bool isSearchName = false;
  int start = 0;
  TagSearch stSearchName = TagSearch.none();
  void init() async {
    _listWebsite = HiveServices.getListWebsite();
    _selectWebsite(index: 0);
  }

  void _selectWebsite({required int index}) {
    try {
      websiteNow.value = _listWebsite.listWebsite[index];
      listGrTagSearch.value = websiteNow.value.listgrtag;
      selectedTag.value = [];
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  String getWebsiteNow() {
    return websiteNow.value.website;
  }

  List<String> listStringNameWebsite() {
    List<String> nameWebsite = [];
    for (var element in _listWebsite.listWebsite) {
      nameWebsite.add(element.website);
    }

    if (nameWebsite.isEmpty) {
      nameWebsite = ['null'];
    }
    return nameWebsite;
  }

  void selectTag({required TagSearch tagSearch}) {
    if (isTagSelected(tagSearch)) {
      removeTagSected(tagSearch: tagSearch);
    } else {
      selectedTag.add(tagSearch);
    }
  }

  void removeTagSected({required TagSearch tagSearch}) {
    selectedTag.remove(tagSearch);
  }

  bool isTagSelected(TagSearch tagSearch) {
    for (var element in selectedTag) {
      if (tagSearch.codetag == element.codetag) {
        return true;
      }
    }
    return false;
  }

  void changeWebsite({required String nameWebsite}) {
    for (int i = 0; i < _listWebsite.listWebsite.length; ++i) {
      if (_listWebsite.listWebsite[i].website.compareTo(nameWebsite) == 0) {
        _selectWebsite(index: i);
        break;
      }
    }
  }

  void loadMoreItems() async {
    if (listBooks.isNotEmpty && listBooks.length > 4 && isEnd == false) {
      isLoadMore.value = true;
      try {
        start += listGrTagSearch.first.count;

        if (isSearchName) {
          client.baseURLClient = websiteNow.value.grsearchname
              .getMoreLink(count: start, chooseTags: [stSearchName]);
        } else {
          client.baseURLClient = websiteNow.value.listgrtag.first
              .getMoreLink(count: start, chooseTags: selectedTag);
        }

        final response = await network.excute(router: client);
        listBooks.addAll(_fetchDataListBookHTML(response));
        if (listBooks.isEmpty) isEnd = true;
      } catch (e) {
        if (kDebugMode) print(e);
      }
      isLoadMore.value = false;
    }
  }

  void _search() async {
    isLoading.value = true;
    isEnd = false;
    start = 0;
    if (isSearchName) {
      client.baseURLClient =
          websiteNow.value.grsearchname.linkSearch(chooseTags: [stSearchName]);
    } else {
      client.baseURLClient =
          websiteNow.value.listgrtag.first.linkSearch(chooseTags: selectedTag);
    }

    final response = await network.excute(router: client);
    listBooks.value = _fetchDataListBookHTML(response);
    isLoading.value = false;
  }

  void searchName() async {
    isSearchName = true;
    try {
      stSearchName = websiteNow.value.grsearchname.tags.first;
      stSearchName.codetag = controllerTextSearchName.text;
      websiteNow.value.grsearchname.linkSearch(chooseTags: [stSearchName]);
      _search();
    } catch (e) {
      if (kDebugMode) {
        print('Tìm kiếm lỗi theo tên:{e}');
      }
    }
  }

  List<Book> _fetchDataListBookHTML(dynamic response) {
    if (response is dio.Response) {
      if (response.statusCode == 200) {
        final QuerryGetListBookHTML querry = websiteNow.value.listbookhtml;
        return HTMLHelper().getListBookHtml(
            response: response,
            querryList: querry.querryList,
            queryText: querry.queryText,
            queryAuthor: querry.queryAuthor,
            queryview: querry.queryview,
            queryScr: querry.queryScr,
            queryHref: querry.queryHref,
            domain: querry.domain);
      }
    }
    return [];
  }

  void searchCategory() async {
    isSearchName = false;
    try {
      _search();
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }
}
