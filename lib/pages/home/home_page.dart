import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/home/home_controller.dart';

import 'package:tts_wikitruyen/res/routers/app_router_name.dart';

import 'pages/i_history_page.dart';
import 'pages/i_home_page.dart';

List<Widget> pages = [
  BodyHome(),
  Container(),
  IHistoryPage(),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text("AUDIO"),
          actions: [
            InkWell(
              onTap: () => Get.toNamed(AppRoutesName.search),
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      "Tìm Kiếm",
                    ),
                    Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
        body: pages[_controller.currenPage.value],
        bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              _controller.currenPageFct(indexPage: value);
            },
            currentIndex: _controller.currenPage.value,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Truyện"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_outlined), label: "YouTube"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: "Lịch Sử"),
            ]),
      ),
    );
  }
}
