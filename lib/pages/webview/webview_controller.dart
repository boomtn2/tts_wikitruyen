import 'dart:convert';

import 'package:get/get.dart';
import 'package:tts_wikitruyen/models/bookinfor.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'js_test.dart';

class WVController extends GetxController {
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

  void reload() {
    controller.reload();
  }

  Future loadIndexing() async {
    try {
      final jsonString =
          await controller.runJavaScriptReturningResult(jsLeakChiMuc());
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
      print(e);
    }
  }

  Future loadChapter() async {
    try {
      final jsonString =
          await controller.runJavaScriptReturningResult(jsChapter);

      final data = jsonDecode('$jsonString');
      List<dynamic> jsonList =
          jsonDecode(data); // Phân tích chuỗi JSON thành một danh sách Dart
      Map<String, String> mapData = {};
      // Lặp qua từng phần tử trong danh sách JSON và chuyển đổi thành Map<String, String>
      for (var element in jsonList) {
        String key = element['href'];
        String value = element['textContent'];
        mapData.addAll({key: value});
      }
      // listChuong.clear();
      // listChuong.addAll(mapData);
      listChuong.value = mapData;
    } catch (e) {
      print(e);
    }
  }

  Future selectChiMuc({required String stChimuc}) async {
    try {
      loading.value = true;
      String querry = actionNext.replaceAll('?', stChimuc);

      await controller.runJavaScript(querry);
    } catch (e) {
      print(e);
    }
  }

  Future moTaFCT() async {
    try {
      final jsonString =
          await controller.runJavaScriptReturningResult(textMoTa) as String;
      moTa.value = jsonString;
    } catch (e) {}
  }

  Future theLoaiFCT() async {
    try {
      final jsonString =
          await controller.runJavaScriptReturningResult(theLoaiJS);

      final data = jsonDecode('$jsonString');
      List<dynamic> jsonList =
          jsonDecode(data); // Phân tích chuỗi JSON thành một danh sách Dart
      Map<String, String> mapData = {};
      // Lặp qua từng phần tử trong danh sách JSON và chuyển đổi thành Map<String, String>
      for (var element in jsonList) {
        String key = element['href'];
        String value = element['textContent'];
        mapData.addAll({key: value});
      }

      // theLoai.clear();
      // theLoai.addAll(mapData);
      theLoai.value = mapData;
    } catch (e) {
      print(e);
    }
  }

  void close() {
    controller.clearCache();
    controller.clearLocalStorage();
  }

  BookInfo getBookInfo() {
    List<Map<String, String>> _theLoai = [];

    List<Map<String, String>> _dsChuong = [];

    theLoai.entries.forEach(
      (element) {
        _theLoai.add({element.value: element.key});
      },
    );

    listChuong.entries.forEach(
      (element) {
        _dsChuong.add({element.value: element.key});
      },
    );

    return BookInfo(theLoai: _theLoai, moTa: moTa.value, dsChuong: _dsChuong);
  }

  void download() {}
}
