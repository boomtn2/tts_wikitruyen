import 'dart:async';
import 'dart:convert';

import 'package:tts_wikitruyen/models/models_export.dart';
import 'package:tts_wikitruyen/repositories/bookinfo_repository/i_bookinfor_repository.dart';
import 'package:tts_wikitruyen/repositories/website_repository/i_website_repository.dart';
import 'package:tts_wikitruyen/repositories/website_repository/website_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewBookInforRepositoru implements IBookInforRepository {
  final WebViewController controller = WebViewController();
  Map<String, String> chiMuc = <String, String>{};
  // key: link value: text
  Map<String, String> listChuong = <String, String>{};
  // key: link value: text
  Map<String, String> theLoai = <String, String>{};
  String moTa = '';

  final IWebsiteRepository _websiteRepository = WebsiteRepository();

  Completer completer = Completer<void>();
  Website? website;

  WebviewBookInforRepositoru() {
    _inint();
  }
  void _inint() {
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            completer.complete();
          },
        ),
      );
  }

  Future _loadLink(String link) async {
    try {
      completer = Completer<void>();
      await controller.loadRequest(Uri.parse(link));
    } catch (e) {}
  }

  @override
  Future<BookInfoModel> getBookInfo(BookModel? book,
      {required String idOrLink}) async {
    await _loadLink(idOrLink);
    await completer.future;
    website = await _websiteRepository.findWebsite(link: idOrLink);
    if (website != null) {
      await moTaFCT(website!);
      await theLoaiFCT(website!);
      await indexingAndChapter();
    }

    return BookInfoModel(theLoai: theLoai, moTa: moTa, dsChuong: listChuong);
  }

  Future indexingAndChapter() async {
    if (website != null) {
      await loadIndexing(website!);
      await loadChapter(website!);
    }
  }

  Future loadIndexing(Website website) async {
    try {
      final jsonString = await controller
          .runJavaScriptReturningResult(website.jsleak.jsIndexing);
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
      chiMuc = mapData;
      // In danh sách đã chuyển đổi
    } catch (e) {}
  }

  Future loadChapter(Website website) async {
    try {
      final jsonString = await controller
          .runJavaScriptReturningResult(website.jsleak.jsListChapter);

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
      if (mapData.isNotEmpty) {
        listChuong = mapData;
      }
    } catch (e) {}
  }

  Future selectChiMuc({required String stChimuc}) async {
    try {
      completer = Completer();
      String querry = website!.jsleak.jsActionNext.replaceAll('?', stChimuc);

      await controller.runJavaScript(querry);
      await completer.future;
      await indexingAndChapter();
    } catch (e) {}
  }

  Future moTaFCT(
    Website website,
  ) async {
    try {
      String jsonString = await controller
          .runJavaScriptReturningResult(website.jsleak.jsDescription) as String;
      moTa = jsonString.replaceAll(r"\n\n", r'\n');
    } catch (e) {}
  }

  Future theLoaiFCT(Website website) async {
    try {
      final jsonString = await controller
          .runJavaScriptReturningResult(website.jsleak.jsCategory);

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

      theLoai = mapData;
    } catch (e) {}
  }
}
