import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/presenters/home_presenter/tab_presenter/export.dart';

class HomePresenter extends GetxController {
  RxInt currenPage = 0.obs;
  RxBool isDarkMode = false.obs;

  HomePresenter() {
    _init();
  }

  void _init() {
    isDarkMode.value = Get.isDarkMode;
  }

  void currenPageFct({required int indexPage}) {
    if (indexPage != currenPage.value) {
      switch (indexPage) {
        case 0:
          break;
        case 1:
          Get.find<TabYoutubePresenter>().inint();
          break;
        case 2:
          Get.find<TabHistoryPresenter>().init();
          break;
      }
      currenPage.value = indexPage;
    }
  }

  void changeTheme(bool value) {
    isDarkMode.value
        ? Get.changeThemeMode(ThemeMode.light)
        : Get.changeThemeMode(ThemeMode.dark);
    isDarkMode.value = value;
  }
}
