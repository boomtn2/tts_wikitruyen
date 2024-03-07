import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/html/html.dart';

import 'package:tts_wikitruyen/pages/data_push.dart';
import 'package:tts_wikitruyen/pages/info/download/status_download.dart';
import 'package:tts_wikitruyen/pages/info/tts/tts_controller.dart';
import 'package:tts_wikitruyen/pages/info/webview/webview_controller.dart';
import 'package:tts_wikitruyen/pages/widgets/dialog.dart';
import 'package:dio/dio.dart' as dio;
import '../../model/model.dart';
import '../../services/local/local.dart';

import '../../services/network/network.dart';
import 'tts/enum_state.dart';

class BookInfoController extends GetxController {
  late Book book;
  Rx<String> nameBook = ''.obs;
  Rx<BookInfo> bookInfo = BookInfo(theLoai: {}, moTa: '', dsChuong: {}).obs;
  Rx<StatusLoading> statusLoading = StatusLoading.loading.obs;
  RxList<Book> listBookSame = <Book>[].obs;
  String pathJS = "";
  RxBool isLoadListChapter = false.obs;

  //tts
  ControllerTTS controllerTTS = ControllerTTS();
  WVController controllerWV = WVController();
  NetworkExecuter network = NetworkExecuter();
  Website _website = Website.none();

  RxBool isError = false.obs;
  String messError = '';

  RxBool isModeOffline = false.obs;
  RxBool isFavorite = false.obs;
  RxBool isChapter = false.obs;

  //download
  Rx<Chapter> chapterDownload = Chapter.none().obs;
  RxInt countDownload = 0.obs;
  Rx<StatusDownload> statusDownload = StatusDownload.stop.obs;
  Client client = Client();

  BookInfoController() {
    isModeOffline.value = DataPush.getModeIsOffline();
    isModeOffline.value ? initOffline() : initOnline();
    checkFavorite();
    isLoadListChapter.value = false;
  }

  void initOffline() async {
    book = DataPush.getBook();
    controllerTTS.initInfoTTS();
    isLoadListChapter.value = true;
    bookInfo.value =
        await DatabaseHelper.internal().getBookInfoOffline(book: book);

    String keyNext = bookInfo.value.dsChuong.isNotEmpty
        ? bookInfo.value.dsChuong.entries.first.value
        : '';

    controllerTTS.setInputLocal(
        id: book.id,
        keyChapter: keyNext,
        lschapter: bookInfo.value.dsChuong,
        text: bookInfo.value.moTa,
        titleChapter: 'Mô tả');
  }

  WVController getControllerWV() => controllerWV;

  Future dowLoad() async {
    if (statusDownload.value == StatusDownload.download) {
      Chapter? responseChapter = await _loadChapterOnline(
          path: chapterDownload.value.linkChapter, html: _website.chapterhtml);

      if (responseChapter == null) {
        statusDownload.value = StatusDownload.error;
      } else {
        chapterDownload.value = responseChapter;
        await _saveLocalOffline();
        countDownload.value++;
        try {
          chapterDownload.value.linkChapter =
              Uri.parse(chapterDownload.value.linkNext).toString();
          await Future.delayed(const Duration(seconds: 3));
          await dowLoad();
        } catch (e) {
          statusDownload.value = StatusDownload.stop;
        }
      }
    }
  }

  Future<bool> _saveLocalOffline() async {
    final sqlite = DatabaseHelper.internal();
    int reponse =
        await sqlite.insertBookOffline(item: bookInfo.value, book: book);

    if (reponse == 0) {
      reponse = await sqlite.daTonTai(book.id, sqlite.tableBook);
      if (reponse == 0) {
        messError = 'Khởi tạo database tablebook lỗi!';
        return false;
      }
    }

    int chapterResponse = await sqlite.insertChapter(
        id: book.id,
        nameChapter: chapterDownload.value.title,
        text: chapterDownload.value.text,
        linkChapter: chapterDownload.value.linkChapter);
    if (chapterResponse != 0) {
      return true;
    }
    messError = 'Lưu Chapter lỗi!';
    return false;
  }

  Future<Chapter?> _loadChapterOnline(
      {required String path, required QuerryGetChapterHTML html}) async {
    try {
      client.url = path;
      var response = await NetworkExecuter().excute(router: client);

      if (response is dio.Response && response.statusCode == 200) {
        return HTMLHelper().getChapter(
            response: response,
            querryTextChapter: html.querryTextChapter,
            querryLinkNext: html.querryLinkNext,
            querryLinkPre: html.querryLinkPre,
            querryTitle: html.querryTitle,
            linkChapter: path,
            domain: html.domain);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  bool isSetFist = false;
  void initOnline() async {
    book = DataPush.getBook();
    controllerTTS.initInfoTTS();
    if (isModeOffline.value == false) {
      _initWebsite();
      controllerWV.loadRequest(book.bookPath);
      controllerWV.moTa.listen((p0) {
        bookInfo.value = controllerWV.getBookInfo();
      });
      controllerWV.listChuong.listen((p0) {
        if (isSetFist == false) {
          isSetFist = true;
          chapterDownload.value = Chapter(
              text: '',
              title: p0.entries.first.value,
              linkChapter: p0.entries.first.key,
              linkNext: '',
              linkPre: '');
          controllerTTS.setInput(
              chapterBook: Chapter(
                  text: controllerWV.moTa.value,
                  title: 'Mô tả',
                  linkChapter: '',
                  linkNext: p0.entries.first.key,
                  linkPre: ''),
              html: _website.chapterhtml);
        }
      });
    } else {}
  }

  void _initWebsite() {
    final listWebsite = HiveServices.getListWebsite();
    for (var element in listWebsite.listWebsite) {
      if (book.bookPath.contains(element.domain)) {
        _website = element;
        if (kDebugMode) print(_website.toMap());
      }
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

  void getListBookSameOnline() async {
    // WikiBaseClient wiki = WikiBaseClient()
    //   ..url = PathWiki.search
    //   ..param = {'qs': 1, 'q': book.bookName};
    // final repo = await network.excute(router: wiki);

    // if (repo is dio.Response) {
    //   listBookSame.addAll(DecoreWikiTruyen.getListBook(response: repo));
    // } else {
    //   handleError(error: repo);
    // }
  }

  void selectedChapterOnline(String title, String link) async {
    isChapter.value = true;
    isLoadListChapter.value = true;
    final chapter =
        await controllerTTS.loadChapter(path: link, html: _website.chapterhtml);
    if (chapter != null) {
      controllerTTS.setInput(chapterBook: chapter, html: _website.chapterhtml);
    } else {
      Get.snackbar(
          'Không tải được chapter:', 'Làm ơn kiếm tra lại kết nối mạng');
    }
    isLoadListChapter.value = false;
  }

  void selectedChapterOffline(String key, String title) async {
    isChapter.value = true;
    isLoadListChapter.value = true;
    final chapter = await DatabaseHelper.internal()
        .getTextChapterOffline(id: book.id, nChapter: key);
    if (chapter.compareTo('') != 0) {
      controllerTTS.setInputLocal(
          id: book.id,
          keyChapter: key,
          lschapter: bookInfo.value.dsChuong,
          text: chapter,
          titleChapter: title);
    } else {
      Get.snackbar(
          'Không tải được chapter:', 'Làm ơn kiếm tra lại kết nối mạng');
    }
    isLoadListChapter.value = false;
  }

  void saveHistoryBook() {
    book.history =
        History(nameChapter: nameChapterNow(), chapterPath: '', text: '');

    DatabaseHelper.internal().insertBookHistory(book: book);
    DatabaseHelper.internal().insertHistory(
        id: book.id, linkChapter: '', nameChapter: nameChapterNow(), text: '');
  }

  String nameChapterNow() {
    return controllerTTS.chapter.value.title;
  }

  RxMap getVoiceNow() {
    return controllerTTS.voiceNow;
  }

  void saveFavorite() async {
    if (isFavorite.value == false) {
      final int response =
          await DatabaseHelper.internal().insertBookFavorite(book: book);
      if (response != 0) {
        isFavorite.value = true;
      }
      Get.snackbar('Lưu yêu thích:', response != 0 ? 'Thành công' : 'Thất bại');
    }
  }

  void checkFavorite() async {
    final sql = DatabaseHelper.internal();
    int response = await sql.daTonTai(book.id, sql.tableBookFavorite);
    if (response != 0) {
      isFavorite.value = true;
    } else {
      isFavorite.value = false;
    }
  }
}
