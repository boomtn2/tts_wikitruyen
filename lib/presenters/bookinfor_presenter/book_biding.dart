import 'package:get/get.dart';
import 'package:tts_wikitruyen/presenters/bookinfor_presenter/bookinfor_presenter.dart';

class BookInfoBiding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      fenix: true,
      () => BookInforPresenter(),
    );
  }
}
