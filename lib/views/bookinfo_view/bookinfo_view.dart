import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tts_wikitruyen/presenters/bookinfor_presenter/bookinfor_presenter.dart';
import 'package:tts_wikitruyen/untils/themes_until/theme_config.dart';
import 'package:tts_wikitruyen/views/bookinfo_view/tab_view/tab_audio/tab_audio.dart';
import 'package:tts_wikitruyen/views/bookinfo_view/tab_view/tab_readbook.dart';
import 'package:tts_wikitruyen/views/bookinfo_view/widgets/dialog_download.dart';

import 'tab_view/tab_bookinfor.dart';

class BookInfoPage extends StatelessWidget {
  const BookInfoPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
        length: 3, initialIndex: 0, child: TabView());
  }
}

class TabView extends StatefulWidget {
  const TabView({super.key});

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  final _controller = Get.find<BookInforPresenter>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    DefaultTabController.of(context).addListener(() {
      _controller.selectTab(DefaultTabController.of(context).index);
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.saveHistory();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Get.dialog(DialogDownload());
              },
              icon: const Icon(Icons.download)),
          Obx(() => IconButton(
              onPressed: () {
                _controller.saveFavorite();
              },
              icon: Icon(
                Icons.favorite,
                color: _controller.isFavorite.value ? Colors.red : null,
              ))),
          IconButton(
              onPressed: () {
                _controller.reloadChapters();
              },
              icon: const Icon(Icons.replay_outlined)),
        ],
      ),
      body: TabBarView(children: [
        TabBookInfor(),
        TabAudio(),
        TabReadBook(),
      ]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBarTheme(
            data: const BottomNavigationBarThemeData(
              selectedItemColor: ThemeUntil.colorChosseTag,
              unselectedItemColor: Colors.grey,
              selectedIconTheme:
                  IconThemeData(color: ThemeUntil.colorChosseTag),
              selectedLabelStyle: TextStyle(fontSize: 16.0),
            ),
            child: BottomNavigationBar(
                currentIndex: _controller.currentIndexTab.value,
                onTap: (value) {
                  DefaultTabController.of(context).index = value;
                },
                items: const [
                  BottomNavigationBarItem(
                    label: 'Truyện',
                    icon: Icon(Icons.book),
                  ),
                  BottomNavigationBarItem(
                      label: 'AUDIO',
                      icon: CircleAvatar(
                        radius: 15,
                        child: Icon(
                          Icons.play_arrow_outlined,
                        ),
                      )),
                  BottomNavigationBarItem(
                      label: 'ĐỌC', icon: Icon(Icons.menu_book)),
                ])),
      ),
    );
  }
}
