import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/presenters/home_presenter/home_presenter.dart';

import 'package:tts_wikitruyen/untils/routers_until/app_router_name.dart';

import 'tab_view/tab_history.dart';
import 'tab_view/tab_home.dart';
import 'tab_view/tab_youtube.dart';

final List<Widget> pages = [
  TabHome(),
  TabYoutube(),
  TabHistory(),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = Get.find<HomePresenter>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          appBar: AppBar(
            title: const Text("AUDIO"),
            actions: [
              ButtonSearch(),
            ],
          ),
          body: pages[_controller.currenPage.value],
          bottomNavigationBar: BottomNaviga()),
    );
  }
}

class ButtonSearch extends StatelessWidget {
  ButtonSearch({super.key});
  final controller = Get.find<HomePresenter>();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutesName.search),
      child: const Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('Tìm kiếm'),
            Icon(
              color: Colors.black,
              Icons.search,
              size: 30,
            ),
          ]),
        ),
      ),
    );
  }
}

class SwitchChangeTheme extends StatelessWidget {
  SwitchChangeTheme({super.key});
  final _controller = Get.find<HomePresenter>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Switch(
        value: _controller.isDarkMode.value,
        onChanged: (value) {
          _controller.changeTheme(value);
        },
      ),
    );
  }
}

class BottomNaviga extends StatelessWidget {
  BottomNaviga({super.key});
  final _controller = Get.find<HomePresenter>();
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap: (value) {
          _controller.currenPageFct(indexPage: value);
        },
        currentIndex: _controller.currenPage.value,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Truyện"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined), label: "YouTube"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Lịch Sử"),
        ]);
  }
}
