import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/repositories/bookmodel_repository/i_bookmodel_repository.dart';
import 'package:tts_wikitruyen/repositories/bookmodel_repository/network_bookmodel_repository.dart';
import 'package:tts_wikitruyen/repositories/website_repository/i_website_repository.dart';
import 'package:tts_wikitruyen/repositories/website_repository/website_repository.dart';

import '../../models/models_export.dart';

class SearchPresenter extends GetxController {
  SearchPresenter() {
    init();
  }
  RxList<BookModel> listBooks = <BookModel>[].obs;
  TextEditingController controllerTextSearchName = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  bool isEnd = false;

  RxList<GroupTagSearch> listGrTagSearch = <GroupTagSearch>[].obs;
  RxList<TagSearch> selectedTag = <TagSearch>[].obs;

  Rx<ListWebsite> listWebsite = ListWebsite.none().obs;
  Rx<Website> websiteNow = Website.none().obs;
  bool isSearchName = false;
  int start = 0;
  TagSearch stSearchName = TagSearch.none();

  final IBookModelReporitory _networkBookRepo = NetWorkBookModelRepository();
  final IWebsiteRepository _websiteRepository = WebsiteRepository();
  void init() async {
    listWebsite.value = await _websiteRepository.getListWebsite();
    if (listWebsite.value.listWebsite.isNotEmpty) {
      _selectWebsite(index: 0);
    }
  }

  void _selectWebsite({required int index}) {
    try {
      websiteNow.value = listWebsite.value.listWebsite[index];
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
    for (var element in listWebsite.value.listWebsite) {
      nameWebsite.add(element.website);
    }

    if (nameWebsite.isEmpty) {
      nameWebsite = ['null', 'null'];
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
    for (int i = 0; i < listWebsite.value.listWebsite.length; ++i) {
      if (listWebsite.value.listWebsite[i].website.compareTo(nameWebsite) ==
          0) {
        _selectWebsite(index: i);
        break;
      }
    }
  }

  void loadMoreItems() async {
    if (listBooks.isNotEmpty && listBooks.length > 4 && isEnd == false) {
      isLoadMore.value = true;

      start += listGrTagSearch.first.count;
      String link = '';
      if (isSearchName) {
        link = websiteNow.value.grsearchname
            .getMoreLink(count: start, chooseTags: [stSearchName]);
      } else {
        link = websiteNow.value.listgrtag.first
            .getMoreLink(count: start, chooseTags: selectedTag);
      }

      final data = await _networkBookRepo.getListBookModel(
          tableOption: TableOption.search, link: link);
      if (data != null) {
        listBooks.addAll(data);
      } else {
        isEnd = true;
      }

      isLoadMore.value = false;
    }
  }

  void _search() async {
    isLoading.value = true;
    isEnd = false;
    start = 0;
    String link = '';
    if (isSearchName) {
      link =
          websiteNow.value.grsearchname.linkSearch(chooseTags: [stSearchName]);
    } else {
      link =
          websiteNow.value.listgrtag.first.linkSearch(chooseTags: selectedTag);
    }

    final data = await _networkBookRepo.getListBookModel(
        tableOption: TableOption.search, link: link);
    if (data != null) {
      listBooks.value = data;
    } else {
      listBooks.value = [];
    }
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

  void searchCategory() async {
    isSearchName = false;
    try {
      _search();
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }
}
