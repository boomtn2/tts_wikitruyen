import 'package:get/get.dart';
import 'package:tts_wikitruyen/models/book.dart';
import 'package:tts_wikitruyen/pages/info/book_info_controller.dart';

class BookInfoBiding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookInfoController>(
      () => BookInfoController(book: Get.find<Book>(tag: 'Page BookInfo')),
    );
  }
}
