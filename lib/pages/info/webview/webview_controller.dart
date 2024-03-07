import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/html/html.dart';
import 'package:tts_wikitruyen/html/html_model.dart';
import 'package:tts_wikitruyen/services/local/hive/hive_service.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../../model/model.dart';

class WVController extends GetxController {
  WVController() {
    _listWebsite = HiveServices.getListWebsite();
  }

  ListWebsite _listWebsite = ListWebsite.none();
  Website _website = Website.none();

  RxBool loading = false.obs;
  //key: chiMuc value: class
  RxMap<String, String> chiMuc = <String, String>{}.obs;
  // key: link value: text
  RxMap<String, String> listChuong = <String, String>{}.obs;
  // key: link value: text
  RxMap<String, String> theLoai = <String, String>{}.obs;
  final WebViewController controller = WebViewController();
  RxString moTa = ''.obs;

  void inintHandleListenEvent() {
    listChuong.listen((p0) {
      if (listChuong.isEmpty) {
        Get.snackbar('Lỗi:',
            'Hiển thị danh sách chương thất bại! \n Yêu cầu bấm nút reload 🔄️');
      }
    });
  }

  void loadRequest(String link) {
    findWebsiteToLink(link);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            loading.value = true;
          },
          onPageFinished: (String url) async {
            if (moTa.value.isEmpty) {
              await theLoaiFCT();
              await moTaFCT();
            }
            await Future.delayed(const Duration(seconds: 1));
            await loadChapter();
            await loadIndexing();

            loading.value = false;
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(link));
  }

  void findWebsiteToLink(String link) {
    try {
      final uri = Uri.parse(link);
      String domain = uri.host;
      for (var element in _listWebsite.listWebsite) {
        if (element.domain.contains(domain)) {
          _website = element;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi find website $e');
      }
    }
  }

  void reload() {
    controller.reload();
  }

  Future loadIndexing() async {
    try {
      final jsonString = await controller
          .runJavaScriptReturningResult(_website.jsleak.jsIndexing);
      final data = jsonDecode('$jsonString');
      List<dynamic> jsonList =
          jsonDecode(data); // Phân tích chuỗi JSON thành một danh sách Dart
      Map<String, String> mapData = {};
      // Lặp qua từng phần tử trong danh sách JSON và chuyển đổi thành Map<String, String>
      for (var element in jsonList) {
        String key = element['textContent'];
        String value = element['liClasses'];
        mapData.addAll({key: value});
      }

      // chiMuc.clear();
      // chiMuc.addAll(mapData);
      chiMuc.value = mapData;
      // In danh sách đã chuyển đổi
    } catch (e) {
      if (kDebugMode) {
        print('loadIndexing $e ${_website.jsleak.jsIndexing}');
      }
    }
  }

  Future loadChapter() async {
    try {
      final jsonString = await controller
          .runJavaScriptReturningResult(_website.jsleak.jsListChapter);

      final data = jsonDecode('$jsonString');
      List<dynamic> jsonList =
          jsonDecode(data); // Phân tích chuỗi JSON thành một danh sách Dart
      Map<String, String> mapData = {};
      // Lặp qua từng phần tử trong danh sách JSON và chuyển đổi thành Map<String, String>
      for (var element in jsonList) {
        String key = Uri.tryParse(element['href']).toString();
        String value = element['textContent'];
        mapData.addAll({key: value});
      }
      // listChuong.clear();
      // listChuong.addAll(mapData);
      listChuong.value = mapData;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future selectChiMuc({required String stChimuc}) async {
    try {
      loading.value = true;
      String querry = _website.jsleak.jsActionNext.replaceAll('?', stChimuc);

      await controller.runJavaScript(querry);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future moTaFCT() async {
    try {
      final jsonString = await controller.runJavaScriptReturningResult(
          _website.jsleak.jsDescription) as String;
      moTa.value = jsonString.trim();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future theLoaiFCT() async {
    try {
      final jsonString = await controller
          .runJavaScriptReturningResult(_website.jsleak.jsCategory);

      final data = jsonDecode('$jsonString');
      List<dynamic> jsonList =
          jsonDecode(data); // Phân tích chuỗi JSON thành một danh sách Dart
      Map<String, String> mapData = {};
      // Lặp qua từng phần tử trong danh sách JSON và chuyển đổi thành Map<String, String>
      for (var element in jsonList) {
        String key = element['textContent'];
        String value = element['href'];
        mapData.addAll({key: value});
      }

      // theLoai.clear();
      // theLoai.addAll(mapData);
      theLoai.value = mapData;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void close() {
    controller.clearCache();
    controller.clearLocalStorage();
  }

  BookInfo getBookInfo() {
    return BookInfo(theLoai: theLoai, moTa: moTa.value, dsChuong: listChuong);
  }

  void download() {}
}
