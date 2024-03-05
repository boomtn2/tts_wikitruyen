import 'package:get/get.dart';
import 'package:tts_wikitruyen/models/book.dart';

import 'package:tts_wikitruyen/models/tag_custom.dart';
import 'package:tts_wikitruyen/res/routers/app_router_name.dart';

import 'package:dio/dio.dart' as dio;
import 'package:tts_wikitruyen/services/local/hive/hive_service.dart';
import 'package:tts_wikitruyen/services/network/client_netword.dart';
import 'package:tts_wikitruyen/services/network/network_excute.dart';
import 'package:tts_wikitruyen/services/network/untils/untils.dart';
import 'package:tts_wikitruyen/services/gist_data/strings_link_connection.dart';
import 'package:tts_wikitruyen/services/wiki_truyen/decore_wikitruyen.dart';
import 'package:tts_wikitruyen/services/wiki_truyen/path_wiki.dart';

import '../../services/gist_data/decore_gist.dart';

class HomeController extends GetxController {
  RxList<Book> listBooks = <Book>[].obs;
  RxInt currenPage = 0.obs;
  RxList<TagCustom> hotTags = <TagCustom>[].obs;
  RxInt indexHotTag = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  int start = 0;

  List<String> tagHistory = ['Hôm nay', 'Yêu Thích', 'Tác Giả Theo Dõi'];
  RxInt indexTagHistory = 0.obs;
  RxList<Book> listHistory = <Book>[].obs;

  NetworkExecuter network = NetworkExecuter();

  RxBool isError = false.obs;

  ErrorNetWork? errorNetWork;
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
          break;
      }
      currenPage.value = indexPage;
    }
  }

  init() async {
    isError.value = false;
    errorNetWork = null;
    final git = Client()..baseURLClient = StringLinkConnection.hotTags;
    var gistReponse = await network.excute(router: git);
    if (gistReponse is dio.Response) {
      hotTags.value = DecoreGist.listTagCustom(response: gistReponse);
      if (hotTags.isNotEmpty) {
        indexHotTag.value = 0;
        getListBooks();
        start = 0;
      }
    } else {
      handleError(error: gistReponse);
    }
  }

  void handleError({required Object error}) {
    if (error is ErrorNetWork) {
      isError.value = true;
      errorNetWork = error;
    }
  }

  void selectTag({required int indexTag}) {
    if (isLoading.value == false) {
      indexHotTag.value = indexTag;

      start = 0;
      getListBooks();
    }
  }

  void loadMoreItems() async {
    isLoadMore.value = true;
    hotTags[indexHotTag.value].params['start'] = '${start += 20}';
    await loading(isLoadNew: false);
    isLoadMore.value = false;
  }

  void getListBooks() async {
    isLoading.value = true;

    //param
    hotTags[indexHotTag.value].params['start'] = '$start';
    await loading(isLoadNew: true);
    isLoading.value = false;
  }

  Future<void> loading({required bool isLoadNew}) async {
    WikiBaseClient wiki = WikiBaseClient()
      ..url = PathWiki.search
      ..param = hotTags[indexHotTag.value].params;
    final repo = await network.excute(router: wiki);

    if (repo is dio.Response) {
      if (isLoadNew) {
        listBooks.value = DecoreWikiTruyen.getListBook(response: repo);
      } else {
        listBooks.addAll(DecoreWikiTruyen.getListBook(response: repo));
      }
    } else {
      handleError(error: repo);
    }
  }

  void nextToBookInfor({required Book book}) {
    Get.lazyPut(() => book, tag: 'Page BookInfo');

    Get.toNamed(AppRoutesName.bookInfo);
  }
}
