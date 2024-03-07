import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:tts_wikitruyen/html/html.dart';
import 'package:tts_wikitruyen/pages/data_push.dart';

import 'package:tts_wikitruyen/res/routers/app_router_name.dart';
import 'package:tts_wikitruyen/res/string_link/string_link.dart';

import 'package:tts_wikitruyen/services/local/local.dart';
import 'package:tts_wikitruyen/services/network/client_netword.dart';

import 'package:tts_wikitruyen/services/network/network_excute.dart';
import 'package:tts_wikitruyen/services/network/untils/untils.dart';

import '../../model/model.dart';
import 'package:dio/dio.dart' as dio;

class HomeController extends GetxController {
  RxList<Book> listBooks = <Book>[].obs;
  RxInt currenPage = 0.obs;

  RxInt indexHotTag = 0.obs;
  RxList<TagHot> listTaghot = <TagHot>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  int start = 0;

  List<String> tagHistory = ['Hôm nay', 'Yêu Thích', 'Tải Về'];
  RxInt indexTagHistory = 0.obs;
  RxList<Book> listHistory = <Book>[].obs;
  RxList<Book> listFavorite = <Book>[].obs;
  RxList<Book> listDownload = <Book>[].obs;
  RxList<Book> listYoutube = <Book>[].obs;

  NetworkExecuter network = NetworkExecuter();

  RxBool isError = false.obs;

  ErrorNetWork? errorNetWork;
  RxBool isModeDark = false.obs;
  Rx<ListWebsite> listWebsite = ListWebsite.none().obs;
  Rx<Website> websiteNow = Website.none().obs;
  Client client = Client();
  QuerryGetListBookHTML _querryGetListBookHTML = QuerryGetListBookHTML.none();
  HomeController() {
    init();
  }

  void currenPageFct({required int indexPage}) {
    if (indexPage != currenPage.value) {
      switch (indexPage) {
        case 0:
          break;
        case 1:
          _initYoutubePage();
          break;
        case 2:
          _initSQLite();
          break;
      }
      currenPage.value = indexPage;
    }
  }

  _initYoutubePage() async {
    client.baseURLClient = linkYoutube;
    final response = await network.excute(router: client);
    if (response is dio.Response) {
      try {
        List json = jsonDecode(response.data) as List;
        List<Book> lis = [];
        for (var element in json) {
          Book book = Book.json(element);
          History history = History.json(element);
          book.history = history;
          lis.add(book);
        }

        listYoutube.value = lis;
      } catch (e) {
        if (kDebugMode) {
          print("fct: _initYoutubePage {$e}");
        }
      }
    }
  }

  _initSQLite() async {
    listHistory.value = await DatabaseHelper.internal().getListBookHistory();
    listFavorite.value = await DatabaseHelper.internal().getListBookFavorite();
    listDownload.value = await DatabaseHelper.internal().getListBookOffline();
  }

  void deleteFavorite(Book bookfvt) async {
    int rp = await DatabaseHelper.internal().deleteBookFavorite(bookfvt.id);
    if (rp != 0) {
      Get.snackbar('Bỏ theo dõi:', bookfvt.bookName);
      listFavorite.value =
          await DatabaseHelper.internal().getListBookFavorite();
    }
  }

  void reloadBookOffline() async {
    listDownload.value = await DatabaseHelper.internal().getListBookOffline();
  }

  Future init() async {
    isLoading.value = true;
    isError.value = false;
    errorNetWork = null;

    listWebsite.value = HiveServices.getListWebsite();
    websiteNow.value = listWebsite.value.listWebsite.first;
    _querryGetListBookHTML = websiteNow.value.listbookhtml;
    listTaghot.value = websiteNow.value.listtaghot;

    await _getDataTagHot(index: 0);
    isLoading.value = false;
  }

  void selectWebsite(int index) async {
    websiteNow.value = listWebsite.value.listWebsite[index];
    isLoading.value = true;
    isError.value = false;
    errorNetWork = null;

    listWebsite.value = HiveServices.getListWebsite();
    _querryGetListBookHTML = websiteNow.value.listbookhtml;
    listTaghot.value = websiteNow.value.listtaghot;

    await _getDataTagHot(index: 0);
    isLoading.value = false;
  }

  Future _getDataTagHot({required int index}) async {
    isLoading.value = true;
    if (listTaghot.isNotEmpty && index < listTaghot.length) {
      indexHotTag.value = index;
      start = 0;
      await _getDataURL(websiteNow.value.listtaghot[index].link);
    }
    isLoading.value = false;
  }

  Future _getDataURL(String url) async {
    client.baseURLClient = url;
    final reponse = await network.excute(router: client);
    if (reponse is dio.Response) {
      listBooks.value = HTMLHelper().getListBookHtml(
          response: reponse,
          querryList: _querryGetListBookHTML.querryList,
          queryText: _querryGetListBookHTML.queryText,
          queryAuthor: _querryGetListBookHTML.queryAuthor,
          queryview: _querryGetListBookHTML.queryview,
          queryScr: _querryGetListBookHTML.queryScr,
          queryHref: _querryGetListBookHTML.queryHref,
          domain: _querryGetListBookHTML.domain);
    } else if (reponse is ErrorNetWork) {
      isError.value = false;
      errorNetWork = reponse;
    } else {}
  }

  void handleError({required Object error}) {
    if (error is ErrorNetWork) {
      isError.value = true;
      errorNetWork = error;
    }
  }

  void selectTag({required int indexTag}) {
    if (isLoading.value == false) {
      _getDataTagHot(index: indexTag);
    }
  }

  void loadMoreItems() async {
    if (listBooks.isNotEmpty) {
      isLoadMore.value = true;
      start += listTaghot[indexHotTag.value].count;
      await _getMoreData(
          listTaghot[indexHotTag.value].linkLoadMore(countInt: start));
      isLoadMore.value = false;
    }
  }

  Future _getMoreData(String url) async {
    client.baseURLClient = url;
    final reponse = await network.excute(router: client);
    if (reponse is dio.Response) {
      listBooks.addAll(HTMLHelper().getListBookHtml(
          response: reponse,
          querryList: _querryGetListBookHTML.querryList,
          queryText: _querryGetListBookHTML.queryText,
          queryAuthor: _querryGetListBookHTML.queryAuthor,
          queryview: _querryGetListBookHTML.queryview,
          queryScr: _querryGetListBookHTML.queryScr,
          queryHref: _querryGetListBookHTML.queryHref,
          domain: _querryGetListBookHTML.domain));
    } else if (reponse is ErrorNetWork) {
      isError.value = false;
      errorNetWork = reponse;
    } else {}
  }

  void nextToBookInfor({required Book book}) {
    DataPush.pushBook(book: book);

    Get.toNamed(AppRoutesName.bookInfo);
  }
}
