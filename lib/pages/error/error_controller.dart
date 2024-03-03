import 'package:get/get.dart';

class ErrorController extends GetxController {
  ErrorController() {
    isError.listen((p0) {
      if (p0) {
        Get.snackbar('Lỗi', messError);
      }
    });
  }
  RxBool isError = false.obs;
  String messError = '';

  init() {
    isError.value = false;
    messError = '';
  }
}
