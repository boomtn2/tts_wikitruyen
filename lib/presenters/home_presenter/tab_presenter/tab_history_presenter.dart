import 'package:get/get.dart';
import 'package:tts_wikitruyen/repositories/bookmodel_repository/local_bookmodel_repository.dart';

import '../../../models/models_export.dart';
import '../../../repositories/bookmodel_repository/i_bookmodel_repository.dart';

import 'enum_loadstatus.dart';

class TabHistoryPresenter extends GetxController {
  List<String> tagHistory = ['Hôm nay', 'Yêu Thích', 'Tải Về'];
  RxInt indexTagHistory = 0.obs;
  RxList<BookModel> listHistory = <BookModel>[].obs;
  RxList<BookModel> listFavorite = <BookModel>[].obs;
  RxList<BookModel> listDownload = <BookModel>[].obs;

  Rx<LoadStatus> statusLoadMore = LoadStatus.succes.obs;
  Rx<LoadStatus> statusLoadList = LoadStatus.succes.obs;
  final IBookModelReporitory _localBookmodelRepository =
      LocalBookModelRepository();
  int max = 5;
  List<BookModel> _temp = [];
  bool isLoadMore = false;

  void init() {
    selectTagHot(0);
  }

  void loadMore() async {
    statusLoadMore.value = LoadStatus.loading;
    int start = 0;
    int end = listHistory.length + max;
    await Future.delayed(const Duration(milliseconds: 300));
    if (_temp.length > end) {
      listHistory.value = List.from(_temp.getRange(start, end));
    } else {
      statusLoadMore.value = LoadStatus.max;
      listHistory.value = List.from(_temp.getRange(start, _temp.length));
    }

    statusLoadMore.value = LoadStatus.succes;
  }

  void deleteHisttory() async {
    await _localBookmodelRepository.deleteBookModel(
        tableOption: TableOption.history, bookModel: BookModel.none());
    _dataHistory();
  }

  void _dataFavorite() async {
    final data = await _localBookmodelRepository.getListBookModel(
        tableOption: TableOption.favorit);

    if (data != null) {
      listFavorite.value = data.reversed.toList();
    }
  }

  void _dataHistory() async {
    final data = await _localBookmodelRepository.getListBookModel(
        tableOption: TableOption.history);

    if (data != null) {
      _temp = data.reversed.toList();
      listHistory.value = [];
      loadMore();
    }
  }

  void _dataDownload() async {
    final data = await _localBookmodelRepository.getListBookModel(
        tableOption: TableOption.offline);

    if (data != null) {
      listDownload.value = data.reversed.toList();
    }
  }

  void selectTagHot(int indexTagHot) {
    switch (indexTagHot) {
      case 0:
        indexTagHistory.value = 0;
        _dataHistory();
        break;
      case 1:
        indexTagHistory.value = 1;
        _dataFavorite();
        break;
      case 2:
        indexTagHistory.value = 2;
        _dataDownload();
        break;
    }
  }

  void deleteBookDownload(BookModel bookClick) {
    _localBookmodelRepository.deleteBookModel(
        bookModel: bookClick, tableOption: TableOption.offline);
    _dataDownload();
  }

  void deleteBookFavorite(BookModel bookClick) {
    _localBookmodelRepository.deleteBookModel(
        bookModel: bookClick, tableOption: TableOption.favorit);
    _dataFavorite();
  }
}
