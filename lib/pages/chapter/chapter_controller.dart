import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/tts/tts_controller.dart';
import 'package:tts_wikitruyen/services/wiki_truyen/convert_html.dart';
import 'package:tts_wikitruyen/services/wiki_truyen/decore_wikitruyen.dart';

import '../tts/enum_state.dart';

class ChapterController extends GetxController {
  ChapterController({required this.indexChapter, required this.listChapter}) {
    init();
  }
  List<Map<String, String>> listChapter = [];

  int indexChapter = 0;
  RxList<String> chapter = <String>[].obs;
  Rx<StatusLoading> statusLoading = StatusLoading.LOADING.obs;
  late ControllerTTS controllerTTS;
  void init() async {
    statusLoading.value = StatusLoading.LOADING;
    controllerTTS = ControllerTTS();

    controllerTTS.loadNewChapter(
      indexPath: indexChapter,
    );

    chapter.value = controllerTTS.getDataText();
    controllerTTS.data.listen((p0) {
      chapter.value = p0;
    });
    statusLoading.value = StatusLoading.SUCCES;
  }

  String getNameChapter() => '${listChapter[indexChapter].keys}';

  void setChapter({required Map<String, String> choose}) async {
    // statusLoading.value = StatusLoading.LOADING;
    // indexChapter = getIndexChapterInList(choose: choose);
    // var response = await ServiceWikitruyen()
    //     .request(path: listChapter[indexChapter].entries.first.value);

    // controllerTTS.setInput(
    //     pathChapters: listChapter,
    //     text: ConvertHtml.getChapter(response: response),
    //     indexPathChapters: indexChapter,
    //     indexLineTexts: 0,
    //     tilte: getNameChapter());

    // chapter.value = controllerTTS.getDataText();
    // statusLoading.value = StatusLoading.SUCCES;
  }

  int getIndexChapterInList({required Map<String, String> choose}) {
    for (int i = 0; i < listChapter.length; ++i) {
      if (listChapter[i] == choose) {
        return i;
      }
    }
    return 0;
  }
}
