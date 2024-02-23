import 'package:get/get.dart';
import 'package:tts_wikitruyen/models/bookinfor.dart';

import 'package:tts_wikitruyen/pages/tts/tts_controller.dart';
import 'package:tts_wikitruyen/res/routers/app_router_name.dart';

import 'package:tts_wikitruyen/services/wiki_truyen/convert_html.dart';
import 'package:tts_wikitruyen/services/wiki_truyen/service_wikitruyen.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:flutter/services.dart';
import '../../models/book.dart';
import '../tts/enum_state.dart';

class BookInfoController extends GetxController {
  Book book;
  Rx<String> nameBook = ''.obs;
  Rx<BookInfo> bookInfo = BookInfo(theLoai: [], moTa: '', dsChuong: []).obs;
  Rx<StatusLoading> statusLoading = StatusLoading.LOADING.obs;
  RxList<Book> listBookSame = <Book>[].obs;
  String pathJS = "";
  RxBool isLoadMore = false.obs;
  final ServiceWikitruyen _serviceWikitruyen = ServiceWikitruyen();
  //tts
  ControllerTTS controllerTTS = ControllerTTS();

  BookInfoController({required this.book}) {
    init();
  }

  void init() async {
    statusLoading.value = StatusLoading.LOADING;
    nameBook.value = book.bookName;
    pathJS = await rootBundle.loadString('assets/js/js_wikitruyen.js');
    await getInfoBook();
    getListBookSame();

    controllerTTS.setInput(
        pathChapters: bookInfo.value.dsChuong,
        indexPathChapters: -1,
        text: bookInfo.value.moTa,
        indexLineTexts: 0,
        tilte: 'Mô tả');

    statusLoading.value = StatusLoading.SUCCES;
  }

  void setChapter({required Map<String, String> choose}) async {
    int indexPath = getIndexChapterInList(choose: choose);
    controllerTTS.loadNewChapter(indexPath: indexPath);
  }

  int getIndexChapterInList({required Map<String, String> choose}) {
    for (int i = 0; i < bookInfo.value.dsChuong.length; ++i) {
      if (bookInfo.value.dsChuong[i] == choose) {
        return i;
      }
    }
    return 0;
  }

  void nextToChapterPage({required Map<String, String> choose}) {
    int indexChapter = getIndexChapterInList(choose: choose);

    Get.lazyPut(() => indexChapter, tag: 'index chapter');
    Get.lazyPut(() => bookInfo.value.dsChuong, tag: 'listChapter');
    Get.toNamed(AppRoutesName.chapter);
  }

  void getListBookSame() async {
    var response = await _serviceWikitruyen
        .search(param: {'qs': 1, 'q': "${book.bookName}"});
    listBookSame.addAll(ConvertHtml.listBook(response: response));
  }

  Future<void> getInfoBook() async {
    //danh sach chuong
    try {
      var _reponse = await _serviceWikitruyen.request(path: book.bookPath);

      BookInfo info = ConvertHtml.getBook(response: _reponse);
      String funcJS = ConvertHtml.extractFuzzySign(_reponse.data) ?? '';
      String bookId = ConvertHtml.extractIdBook(_reponse.data) ?? '';
      String signKey = ConvertHtml.extractSignKey(_reponse.data) ?? '';
      //key sign
      print(funcJS);
      String sign = await evalJS(fuzzySign: funcJS, signKey: signKey);

      var _reponseChuong = await _serviceWikitruyen.loadChapter(
          bookId: bookId, signKey: signKey, sign: sign);

      info.dsChuong = ConvertHtml.getListChapter(response: _reponseChuong);
      bookInfo.value = info;
      statusLoading.value = StatusLoading.SUCCES;
    } catch (e) {
      print("error");
      statusLoading.value = StatusLoading.ERROR;
    }
  }

  Future<String> evalJS(
      {required String fuzzySign,
      required String signKey,
      String start = '0',
      String size = '501'}) async {
    final JavascriptRuntime javascriptRuntime =
        getJavascriptRuntime(forceJavascriptCoreOnAndroid: false);

    String key = signKey + start + size;
    JsEvalResult jsEvalResult =
        javascriptRuntime.evaluate("""${fuzzySign} fuzzySign('${key}')""");

    String keyFuzzySign = jsEvalResult.stringResult;
    print(keyFuzzySign);
    //key sign
    jsEvalResult =
        javascriptRuntime.evaluate("""${pathJS}a('${keyFuzzySign}')""");
    return jsEvalResult.stringResult;
  }
}
