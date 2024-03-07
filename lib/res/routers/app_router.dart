import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/home/home_biding.dart';

import 'package:tts_wikitruyen/pages/home/home_page.dart';
import 'package:tts_wikitruyen/pages/info/book_biding.dart';
import 'package:tts_wikitruyen/pages/info/book_info_page.dart';
import 'package:tts_wikitruyen/pages/search/search_binding.dart';
import 'package:tts_wikitruyen/pages/search/search_page.dart';
import 'package:tts_wikitruyen/pages/splash/splash_page.dart';

import 'app_router_name.dart';

class AppRoutes {
  static final page = [
    GetPage(name: AppRoutesName.splash, page: () => const SplashPage()),
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
      page: () => const BookInfoPage(),
      binding: BookInfoBiding(),
    ),
  ];
}
