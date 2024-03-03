import 'package:get/get.dart';
import 'package:tts_wikitruyen/models/bookinfor.dart';
import 'package:tts_wikitruyen/pages/error/error_controller.dart';
import 'package:tts_wikitruyen/services/network/network.dart';
import 'package:dio/dio.dart' as dio;
import 'package:tts_wikitruyen/services/wiki_truyen/convert_html.dart';

class DownloadController extends GetxController {
  DownloadController({int start = 0, required this.bookInfo}) {
    startDownload.value = start;
    getTextToLink();
  }
  final netWork = NetworkExecuter();
  BookInfo bookInfo;
  RxInt startDownload = 0.obs;
  RxBool isError = false.obs;

  int getLengthLinks() => bookInfo.dsChuong.length;
  final error = Get.find<ErrorController>();
  final client = Client();
  bool isStopDownload = false;
  void getTextToLink() async {
    final links = bookInfo.getListLinks();
    int i = startDownload.value;
    while (isStopDownload != true) {
      if (i >= links.length) {
        break;
      }

      startDownload.value = i;
      client.baseURLClient = links[i];

      final response = await netWork.excute(router: client);
      await Future.delayed(const Duration(seconds: 1));
      if (response is dio.Response) {
        String data = BaseHtml().getChapter(response: response, link: links[i]);
        saveDataInLocal(data);
        i++;
      } else {
        error.isError.value = true;
        error.messError = response.toString();
        break;
      }
    }
  }

  void saveDataInLocal(String data) {
    print(data);
  }
}
