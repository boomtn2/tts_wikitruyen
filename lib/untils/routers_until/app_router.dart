import 'package:get/get.dart';
import 'package:tts_wikitruyen/presenters/home_presenter/home_binding.dart';
import 'package:tts_wikitruyen/presenters/search_presenter/search_binding.dart';

import 'package:tts_wikitruyen/views/home_view/home_view.dart';
import 'package:tts_wikitruyen/presenters/bookinfor_presenter/book_biding.dart';
import 'package:tts_wikitruyen/views/bookinfo_view/bookinfo_view.dart';

import 'package:tts_wikitruyen/views/search_view/search_page.dart';
import 'package:tts_wikitruyen/views/splash_view/splash_page.dart';

import 'app_router_name.dart';

class AppRoutes {
  static final page = [
    GetPage(name: AppRoutesName.splash, page: () => const SplashPage()),
    GetPage(
        name: AppRoutesName.home,
        page: () => const HomePage(),
        binding: HomeBinding()),
    GetPage(
        name: AppRoutesName.search,
        page: () => const SearchPage(),
        binding: SearchBinding()),
    GetPage(
      name: AppRoutesName.bookInfo,
      page: () => const BookInfoPage(),
      binding: BookInfoBiding(),
    ),
  ];
}
