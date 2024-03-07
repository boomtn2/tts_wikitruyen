import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/widgets/itembooklist.dart';

import '../../widgets/bookcard.dart';
import '../home_controller.dart';

// ignore: must_be_immutable
class IHistoryPage extends StatelessWidget {
  IHistoryPage({super.key});
  final _controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: _controller.indexTagHistory.value,
        length: 3,
        child: Builder(builder: (context) {
          DefaultTabController.of(context).addListener(() {
            _controller.indexTagHistory.value =
                DefaultTabController.of(context).index;
          });

          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                  height: 40,
                  width: Get.size.width,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _controller.tagHistory.length,
                      itemBuilder: (context, index) => ButtonTagHotSreach(
                            title: _controller.tagHistory[index],
                            index: index,
                          ))),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    TabViewHistory(),
                    TabViewFavorite(),
                    TabViewDownload()
                  ],
                ),
              ),
            ],
          );
        }));
  }
}

class ButtonTagHotSreach extends StatelessWidget {
  ButtonTagHotSreach({
    super.key,
    required this.title,
    required this.index,
  });
  final String title;
  final int index;
  final _controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          if (_controller.indexTagHistory.value != index) {
            _controller.indexTagHistory.value = index;
            DefaultTabController.of(context).index = index;
          }
        },
        child: Container(
          margin: const EdgeInsets.only(left: 5),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: _controller.indexTagHistory.value == index
                  ? Colors.white
                  : Colors.black,
              border: Border.all(
                color: _controller.indexTagHistory.value == index
                    ? Colors.blue
                    : Colors.white30,
                width: _controller.indexTagHistory.value == index ? 1 : 2,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: _controller.indexTagHistory.value == index
                      ? Colors.black
                      : Colors.white60,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class TabViewHistory extends StatelessWidget {
  TabViewHistory({super.key});
  final _controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: _controller.listHistory.length,
        itemBuilder: (context, index) =>
            BookListItem(book: _controller.listHistory[index]),
      ),
    );
  }
}

class TabViewFavorite extends StatelessWidget {
  TabViewFavorite({super.key});
  final _controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: Card(
                    color: Colors.white,
                    child: Center(
                        child: Text(
                      'Truyện',
                      style: TextStyle(color: Colors.black),
                    )))),
            Card(
                color: Colors.red,
                child: SizedBox(
                    width: 40,
                    child: Center(
                        child: Text(
                      'Xóa',
                      style: TextStyle(color: Colors.white),
                    ))))
          ],
        ),
        Obx(
          () => Expanded(
            child: ListView.builder(
              itemCount: _controller.listFavorite.length,
              itemBuilder: (context, index) => Row(
                children: [
                  Expanded(
                    child: BookListItem(
                      book: _controller.listFavorite[index],
                      optionFull: false,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {},
                    child: const SizedBox(
                        height: 120,
                        width: 40,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TabViewDownload extends StatelessWidget {
  TabViewDownload({super.key});
  final _controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: _controller.listDownload.length,
        itemBuilder: (context, index) =>
            BookCard(book: _controller.listDownload[index]),
      ),
    );
  }
}
