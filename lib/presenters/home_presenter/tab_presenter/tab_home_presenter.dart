import 'package:get/get.dart';

import 'package:tts_wikitruyen/models/models_export.dart';
import 'package:tts_wikitruyen/repositories/bookmodel_repository/i_bookmodel_repository.dart';
import 'package:tts_wikitruyen/repositories/bookmodel_repository/network_bookmodel_repository.dart';
import 'package:tts_wikitruyen/repositories/website_repository/i_website_repository.dart';
import 'package:tts_wikitruyen/repositories/website_repository/website_repository.dart';

import 'enum_loadstatus.dart';

class TabHomePresenter extends GetxController {
  RxList<Website> listWebsite = <Website>[].obs;
  Rx<Website> currentWebsite = Website.none().obs;
  RxList<TagHot> listTaghots = <TagHot>[].obs;
  Rx<int> currenTaghot = 0.obs;
  RxList<BookModel> listBooks = <BookModel>[].obs;
  Rx<LoadStatus> statusLoadMore = LoadStatus.succes.obs;
  Rx<LoadStatus> statusLoadList = LoadStatus.succes.obs;
  final IBookModelReporitory _bookModelReporitory =
      NetWorkBookModelRepository();
  final IWebsiteRepository _websiteRepository = WebsiteRepository();
  // int _maxItem = 10;
  int _indexLoadMore = 0;

  @override
  void onInit() {
    _inint();
    super.onInit();
  }

  void _inint() async {
    _indexLoadMore = 0;

    currenTaghot.value = 0;
    await _dataWebsite();
    if (listWebsite.isNotEmpty) {
      currentWebsite.value = listWebsite.first;
      _dataTagHot();
      await _dataListBook();
    }
  }

  void _dataTagHot() {
    listTaghots.value = currentWebsite.value.listtaghot;
  }

  Future _dataWebsite() async {
    final listWebsite = await _websiteRepository.getListWebsite();
    this.listWebsite.value = listWebsite.listWebsite;
  }

  Future _dataListBook() async {
    statusLoadList.value = LoadStatus.loading;
    final data = await _bookModelReporitory.getListBookModel(
        tableOption: TableOption.home,
        link: listTaghots[currenTaghot.value].link);
    if (data != null) {
      listBooks.value = data;
    }

    statusLoadList.value = LoadStatus.succes;
  }

  void _dataListBookLoadMore() async {
    statusLoadMore.value = LoadStatus.loading;
    _indexLoadMore += listTaghots[currenTaghot.value].count;
    final data = await _bookModelReporitory.getListBookModel(
        tableOption: TableOption.home,
        link: listTaghots[currenTaghot.value]
            .linkLoadMore(countInt: _indexLoadMore));

    if (data != null) {
      listBooks.addAll(data);
    }

    statusLoadMore.value = LoadStatus.succes;
  }

  void selectTagHot(int indexTagHot) {
    if (currenTaghot.value != indexTagHot) {
      currenTaghot.value = indexTagHot;
      _indexLoadMore = 0;
      _dataListBook();
    }
  }

  void selectWebsite(Website website) async {
    if (website.website.compareTo(currentWebsite.value.website) != 0) {
      currentWebsite.value = website;
      _indexLoadMore = 0;
      _dataTagHot();
      await _dataListBook();
    }
  }

  void loadMoreBooks() async {
    _dataListBookLoadMore();
  }
}
