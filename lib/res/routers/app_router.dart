import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/chapter/chapter_page.dart';
import 'package:tts_wikitruyen/pages/home/home_biding.dart';

import 'package:tts_wikitruyen/pages/home/home_page.dart';
import 'package:tts_wikitruyen/pages/info/book_biding.dart';
import 'package:tts_wikitruyen/pages/info/book_info.dart';
import 'package:tts_wikitruyen/pages/search/search_binding.dart';
import 'package:tts_wikitruyen/pages/search/search_page.dart';

import '../../pages/chapter/chapter_binding.dart';
import 'app_router_name.dart';

class AppRoutes {
  static final page = [
    GetPage(
      name: AppRoutesName.home,
      page: () => const HomePage(),
      binding: Homebinding(),
    ),
    GetPage(
      name: AppRoutesName.search,
      page: () => const SearchPage(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: AppRoutesName.bookInfo,
      page: () => BookInfoPage(
        authorTag: Get.find<String>(tag: 'authorTag'),
        imgTag: Get.find<String>(tag: 'imgTag'),
        titleTag: Get.find<String>(tag: 'titleTag'),
      ),
      binding: BookInfoBiding(),
    ),
    GetPage(
      name: AppRoutesName.chapter,
      page: () => const ChapterPage(),
      binding: ChapterBinding(),
    ),
  ];
}
