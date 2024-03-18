import 'package:get/get.dart';

import 'search_presenter.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchPresenter>(
      () => SearchPresenter(),
    );
  }
}
