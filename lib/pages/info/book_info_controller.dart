import 'package:get/get.dart';
import 'package:tts_wikitruyen/models/bookinfor.dart';
import 'package:tts_wikitruyen/pages/download/dialog_download.dart';
import 'package:tts_wikitruyen/pages/download/download_controller.dart';

import 'package:tts_wikitruyen/pages/tts/tts_controller.dart';
import 'package:tts_wikitruyen/pages/webview/webview_controller.dart';
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
  late Book book;
  Rx<String> nameBook = ''.obs;
  Rx<BookInfo> bookInfo = BookInfo(theLoai: [], moTa: '', dsChuong: []).obs;
  Rx<StatusLoading> statusLoading = StatusLoading.loading.obs;
  RxList<Book> listBookSame = <Book>[].obs;
  String pathJS = "";
  RxBool isLoadListChapter = false.obs;

  //tts
  ControllerTTS controllerTTS = ControllerTTS();
  WVController controllerWV = WVController();
  NetworkExecuter network = NetworkExecuter();

  RxBool isError = false.obs;
  String messError = '';

  BookInfoController() {
    book = HiveServices.getBook();
  }

  WVController getControllerWV() => controllerWV;

  void dowLoad() {
    bookInfo.value.book = book;

    Get.dialog(DialogDownLoad(
      controller: DownloadController(bookInfo: bookInfo.value),
      right: () {},
      left: () {},
    ));
  }

  void init() async {
    isError.value = false;
    statusLoading.value = StatusLoading.loading;
    nameBook.value = book.bookName;

    getListBookSame();
    controllerWV.inintHandleListenEvent();
    controllerWV.loadRequest(book.bookPath);

    controllerWV.loading.listen((p0) {
      bookInfo.value = controllerWV.getBookInfo();

      controllerTTS.setInput(
          linksChapter: bookInfo.value.dsChuong,
          indexlinksChapter: -1,
          text: bookInfo.value.moTa,
          indexLineTexts: 0,
          tilte: 'Mô tả');
      statusLoading.value = StatusLoading.succes;
    });
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
