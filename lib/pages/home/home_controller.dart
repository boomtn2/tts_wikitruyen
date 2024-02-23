import 'package:get/get.dart';
import 'package:tts_wikitruyen/models/book.dart';

import 'package:tts_wikitruyen/models/tag_custom.dart';
import 'package:tts_wikitruyen/res/routers/app_router_name.dart';
import 'package:tts_wikitruyen/services/gist_data/service_gist.dart';

import 'package:tts_wikitruyen/services/wiki_truyen/convert_html.dart';
import 'package:tts_wikitruyen/services/wiki_truyen/service_wikitruyen.dart';

import '../../services/gist_data/convert_reponse_gist.dart';

class HomeController extends GetxController {
  RxList<Book> listBooks = <Book>[].obs;
  final ServiceWikitruyen _serviceWikitruyen = ServiceWikitruyen();
  final ServiceGist _serviceGist = ServiceGist();
  RxInt currenPage = 0.obs;
  RxList<TagCustom> hotTags = <TagCustom>[].obs;
  RxInt indexHotTag = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  int start = 0;

  List<String> tagHistory = ['Hôm nay', 'Yêu Thích', 'Tác Giả Theo Dõi'];
  RxInt indexTagHistory = 0.obs;
  HomeController() {
    init();
  }

  init() async {
    var gistReponse = await _serviceGist.getHotTag();
    hotTags.value = ConverReponseGist.listTagCustom(response: gistReponse);
    if (hotTags.isNotEmpty) {
      indexHotTag.value = 0;
      getListBooks();
      start = 0;
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
    print(hotTags[indexHotTag.value].params);
    var response = await _serviceWikitruyen.search(
        param: hotTags[indexHotTag.value].params);

    listBooks.addAll(ConvertHtml.listBook(response: response));

    isLoadMore.value = false;
  }

  void getListBooks() async {
    isLoading.value = true;
    hotTags[indexHotTag.value].params['start'] = '${start}';
    var response = await _serviceWikitruyen.search(
        param: hotTags[indexHotTag.value].params);
    print(hotTags[indexHotTag.value].params);
    // var response = await _serviceWikitruyen.search(param: {
    //   'qs': 1,
    //   '${querryTag}': '${hotTags[chooseHotTag]}',
    //   'm': 2,
    //   'start': 0,
    //   'so': 4,
    //   'y': 2024
    // }
    // );
    listBooks.value = [];
    listBooks.addAll(ConvertHtml.listBook(response: response));
    isLoading.value = false;
  }

  void nextToBookInfor({required Book book}) {
    Get.lazyPut(() => book, tag: 'Page BookInfo');

    Get.toNamed(AppRoutesName.bookInfo);
  }
}
