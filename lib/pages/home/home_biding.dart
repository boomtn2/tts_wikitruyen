import 'package:get/get.dart';
import 'home_controller.dart';

class Homebinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
