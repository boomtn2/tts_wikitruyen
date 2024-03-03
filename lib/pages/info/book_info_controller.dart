import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/models/bookinfor.dart';
import 'package:tts_wikitruyen/pages/download/dialog_download.dart';
import 'package:tts_wikitruyen/pages/download/download_controller.dart';

import 'package:tts_wikitruyen/pages/tts/tts_controller.dart';
import 'package:tts_wikitruyen/pages/widgets/dialog.dart';
import 'package:tts_wikitruyen/res/routers/app_router_name.dart';
import 'package:tts_wikitruyen/services/local/hive/hive_service.dart';
import 'package:tts_wikitruyen/services/network/client_netword.dart';
import 'package:tts_wikitruyen/services/network/network_excute.dart';

import 'package:dio/dio.dart' as dio;
import '../../models/book.dart';
import '../../services/wiki_truyen/decore_wikitruyen.dart';
import '../../services/wiki_truyen/path_wiki.dart';
import '../tts/enum_state.dart';

class BookInfoController extends GetxController {
  Book book;
  Rx<String> nameBook = ''.obs;
  Rx<BookInfo> bookInfo = BookInfo(theLoai: [], moTa: '', dsChuong: []).obs;
  Rx<StatusLoading> statusLoading = StatusLoading.loading.obs;
  RxList<Book> listBookSame = <Book>[].obs;
  String pathJS = "";
  RxBool isLoadListChapter = false.obs;
  RxBool isLoadMore = false.obs;
  //tts
  ControllerTTS controllerTTS = ControllerTTS();
  NetworkExecuter network = NetworkExecuter();
  RxInt maxItemScroll = 20.obs;

  RxBool isError = false.obs;
  String messError = '';
  BookInfoController({required this.book}) {
    init();
  }

  void dowLoad() {
    bookInfo.value.book = book;

    Get.dialog(DialogDownLoad(
      controller: DownloadController(bookInfo: bookInfo.value),
      right: () {},
      left: () {},
    ));
  }

  void loadMoreChapter() async {
    isLoadListChapter.value = true;

    await Future.delayed(const Duration(seconds: 1));
    bookInfo.value.dsChuong.length - maxItemScroll.value > 20
        ? maxItemScroll.value += 20
        : maxItemScroll.value = bookInfo.value.dsChuong.length;
    isLoadListChapter.value = false;
  }

  void init() async {
    isError.value = false;
    statusLoading.value = StatusLoading.loading;
    nameBook.value = book.bookName;

    await loadInfoBook();
    getListBookSame();

    controllerTTS.setInput(
        linksChapter: bookInfo.value.dsChuong,
        indexlinksChapter: -1,
        text: bookInfo.value.moTa,
        indexLineTexts: 0,
        tilte: 'Mô tả');
    if (book.history != null) {
      print(book.history!.chapterPath);
      // controllerTTS.bookMark(
      //     path: book.history!.chapterPath,
      //     chapterName: book.history!.nameChapter,
      //     stringMark: book.history!.text);
    }

    statusLoading.value = StatusLoading.succes;
  }

  Future loadInfoBook() async {
    WikiBaseClient wiki = WikiBaseClient();
    wiki.url = book.bookPath;
    final repo = await network.excute(router: wiki);
    // ignore: no_leading_underscores_for_local_identifiers
    final BookInfo _bookInfo;
    if (repo is dio.Response) {
      _bookInfo = DecoreWikiTruyen.getInfoBook(response: repo);
      wiki = await DecoreWikiTruyen.getKeyChapters(reponseBookInfoNow: repo);

      final repoListChapter = await network.excute(router: wiki);

      if (repoListChapter is dio.Response) {
        _bookInfo.dsChuong =
            DecoreWikiTruyen.getListChapter(response: repoListChapter);
        bookInfo.value = _bookInfo;
        showDialog();
      } else {}
    } else {
      handleError(error: repo);
    }
  }

  void showDialog() {
    if (book.history != null) {
      Get.dialog(DialogCustom(
        right: () {
          Get.back();
        },
        left: () {
          Get.back();
        },
        mess: book.history!.nameChapter,
      ));
    }
  }

  void handleError({required Object error}) {
    isError.value = true;
    messError = '$error';
  }

  void setChapter({required Map<String, String> choose}) async {
    int indexPath = bookInfo.value.getIndexChapterInList(choose: choose);
    controllerTTS.loadNewChapter(indexPath: indexPath);
  }

  void nextToChapterPage({required Map<String, String> choose}) {
    int indexChapter = bookInfo.value.getIndexChapterInList(choose: choose);

    Get.lazyPut(() => indexChapter, tag: 'index chapter');
    Get.lazyPut(() => bookInfo.value.dsChuong, tag: 'listChapter');
    Get.toNamed(AppRoutesName.chapter);
  }

  void getListBookSame() async {
    WikiBaseClient wiki = WikiBaseClient()
      ..url = PathWiki.search
      ..param = {'qs': 1, 'q': book.bookName};
    final repo = await network.excute(router: wiki);

    if (repo is dio.Response) {
      listBookSame.addAll(DecoreWikiTruyen.getListBook(response: repo));
    } else {
      handleError(error: repo);
    }
  }

  void saveHistoryBook() {
    book.history = History(
        nameChapter: nameChapterNow(),
        chapterPath: chapterPath(),
        text: textChapterNow());
    HiveServices.addHistory(book: book);
  }

  String nameChapterNow() {
    return controllerTTS.titleNow.value;
  }

  String textChapterNow() {
    if (controllerTTS.data.isEmpty) {
      return '';
    }
    return controllerTTS.data[controllerTTS.index.value]
        .substring(controllerTTS.end.value);
  }

  String chapterPath() {
    return '';
  }

  RxMap getVoiceNow() {
    return controllerTTS.voiceNow;
  }
}
