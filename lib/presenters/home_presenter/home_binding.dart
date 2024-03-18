import 'package:get/get.dart';

import 'home_presenter.dart';
import 'tab_presenter/export.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TabHistoryPresenter());
    Get.lazyPut(() => TabHomePresenter());
    Get.lazyPut(() => TabYoutubePresenter());
    Get.lazyPut(
      () => HomePresenter(),
    );
  }
}
