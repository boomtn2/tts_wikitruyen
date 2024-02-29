import 'package:get/get.dart';
import 'package:tts_wikitruyen/models/bookinfor.dart';

import 'package:tts_wikitruyen/pages/tts/tts_controller.dart';
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
  Rx<StatusLoading> statusLoading = StatusLoading.LOADING.obs;
  RxList<Book> listBookSame = <Book>[].obs;
  String pathJS = "";
  RxBool isLoadListChapter = false.obs;
  RxBool isLoadMore = false.obs;
  //tts
  ControllerTTS controllerTTS = ControllerTTS();
  NetworkExecuter network = NetworkExecuter();
  RxInt maxItemScroll = 20.obs;

  BookInfoController({required this.book}) {
    init();
  }

  void loadMoreChapter() async {
    isLoadListChapter.value = true;

    await Future.delayed(Duration(seconds: 1));
    bookInfo.value.dsChuong.length - maxItemScroll.value > 20
        ? maxItemScroll.value += 20
        : maxItemScroll.value = bookInfo.value.dsChuong.length;
    isLoadListChapter.value = false;
  }

  void init() async {
    statusLoading.value = StatusLoading.LOADING;
    nameBook.value = book.bookName;

    await loadInfoBook();
    getListBookSame();

    controllerTTS.setInput(
        pathChapters: bookInfo.value.dsChuong,
        indexPathChapters: -1,
        text: bookInfo.value.moTa,
        indexLineTexts: 0,
        tilte: 'Mô tả');

    statusLoading.value = StatusLoading.SUCCES;
  }

  Future loadInfoBook() async {
    WikiBaseClient wiki = WikiBaseClient();
    wiki.url = book.bookPath;
    final repo = await network.excute(router: wiki);
    BookInfo _bookInfo;
    if (repo is dio.Response) {
      _bookInfo = DecoreWikiTruyen.getInfoBook(response: repo);
      wiki = await DecoreWikiTruyen.getKeyChapters(reponseBookInfoNow: repo);

      final repoListChapter = await network.excute(router: wiki);

      if (repoListChapter is dio.Response) {
        _bookInfo.dsChuong =
            DecoreWikiTruyen.getListChapter(response: repoListChapter);
        bookInfo.value = _bookInfo;
      } else {}
    } else {
      handleError(error: repo);
    }
  }

  void handleError({required Object error}) {
    print(error);
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
      ..param = {'qs': 1, 'q': "${book.bookName}"};
    final repo = await network.excute(router: wiki);

    if (repo is dio.Response) {
      listBookSame.addAll(DecoreWikiTruyen.getListBook(response: repo));
    } else {
      handleError(error: repo);
    }
  }

  void saveHistoryBook() {
    print(book.bookName);
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
    // return controllerTTS.data[controllerTTS.index.value]
    //     .substring(controllerTTS.end.value);
    return '';
  }

  String chapterPath() {
    return '';
  }

  RxMap getVoiceNow() {
    return controllerTTS.voiceNow;
  }
}
