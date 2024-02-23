import 'package:get/get.dart';

import 'package:tts_wikitruyen/pages/chapter/chapter_controller.dart';

class ChapterBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChapterController>(() {
      return ChapterController(
          indexChapter: Get.find<int>(tag: 'index chapter'),
          listChapter: Get.find<List<Map<String, String>>>(tag: 'listChapter'));
    });
  }
}
