import 'dart:async';

import 'package:get/get.dart';
import 'package:tts_wikitruyen/html/html.dart';
import 'package:tts_wikitruyen/pages/data_push.dart';

import 'package:tts_wikitruyen/res/routers/app_router_name.dart';

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

  NetworkExecuter network = NetworkExecuter();

  RxBool isError = false.obs;

  ErrorNetWork? errorNetWork;

  ListWebsite _listWebsite = ListWebsite.none();
  Website _websiteNow = Website.none();
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
          break;
        case 2:
          _initSQLite();
          break;
      }
      currenPage.value = indexPage;
    }
  }

  _initSQLite() async {
    listHistory.value = await DatabaseHelper.internal().getListBookHistory();
    listFavorite.value = await DatabaseHelper.internal().getListBookFavorite();
    listDownload.value = await DatabaseHelper.internal().getListBookOffline();
  }

  init() async {
    isLoading.value = true;
    isError.value = false;
    errorNetWork = null;

    _listWebsite = HiveServices.getListWebsite();
    _websiteNow = _listWebsite.listWebsite.first;
    _querryGetListBookHTML = _websiteNow.listbookhtml;
    listTaghot.value = _websiteNow.listtaghot;

    await _getDataTagHot(index: 0);
    isLoading.value = false;
  }

  Future _getDataTagHot({required int index}) async {
    isLoading.value = true;
    if (listTaghot.isNotEmpty && index < listTaghot.length) {
      indexHotTag.value = index;
      start = 0;
      await _getDataURL(_websiteNow.listtaghot[index].link);
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
