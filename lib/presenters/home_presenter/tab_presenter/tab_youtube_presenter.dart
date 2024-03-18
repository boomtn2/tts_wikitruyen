import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tts_wikitruyen/repositories/bookmodel_repository/i_bookmodel_repository.dart';
import 'package:tts_wikitruyen/repositories/bookmodel_repository/network_bookmodel_repository.dart';
import 'package:tts_wikitruyen/repositories/data_push.dart';
import 'package:tts_wikitruyen/untils/api_until/api_until.dart';
import 'package:tts_wikitruyen/untils/routers_until/app_router_name.dart';

import '../../../models/models_export.dart';
import 'enum_loadstatus.dart';

class TabYoutubePresenter extends GetxController {
  RxList<BookModel> listBook = <BookModel>[].obs;
  Rx<LoadStatus> statusLoadMore = LoadStatus.succes.obs;
  Rx<LoadStatus> statusLoadList = LoadStatus.succes.obs;
  TextEditingController controllerLinkBook = TextEditingController();
  List<BookModel> _temp = [];
  int max = 10;
  final IBookModelReporitory _bookmodelRepository =
      NetWorkBookModelRepository();

  void inint() async {
    statusLoadList.value = LoadStatus.loading;
    final data = await _bookmodelRepository.getListBookModel(
        tableOption: TableOption.youtube, link: APIUntil.linkYoutube);
    if (data != null) {
      _temp = data;
      listBook.value = [];
      loadMore();
    }
    statusLoadList.value = LoadStatus.succes;
  }

  void loadMore() async {
    statusLoadMore.value = LoadStatus.loading;
    int start = 0;
    int end = listBook.length + max;
    await Future.delayed(const Duration(milliseconds: 300));
    if (_temp.length > end) {
      listBook.value = List.from(_temp.getRange(start, end));
    } else {
      statusLoadMore.value = LoadStatus.max;
      listBook.value = List.from(_temp.getRange(start, _temp.length));
    }
  }

  void searchLink() {
    Uri? link = Uri.tryParse(controllerLinkBook.value.text);
    if (link != null) {
      BookModel book = BookModel.none();
      book.bookPath = link.toString();
      book.bookName = link.path;
      DataPush.pushBook(book: book);
      Get.toNamed(AppRoutesName.bookInfo);
    } else {
      Get.snackbar('Đường dẫn không hợp lệ!', 'Kiểm tra lại đường dẫn!');
    }
  }
}
