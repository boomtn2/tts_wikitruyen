import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:tts_wikitruyen/presenters/home_presenter/tab_presenter/export.dart';
import 'package:tts_wikitruyen/services/tts/enum_state.dart';
import 'package:tts_wikitruyen/views/home_view/widgets/button_card.dart';
import 'package:tts_wikitruyen/views/widgets/itembooklist.dart';
import 'package:tts_wikitruyen/views/widgets/loading_widget.dart';

import '../widgets/bookcard.dart';

// ignore: must_be_immutable
class TabHistory extends StatelessWidget {
  TabHistory({super.key});
  final _controller = Get.find<TabHistoryPresenter>();

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
                    _TabViewHistory(),
                    _TabViewFavorite(),
                    _TabViewDownload()
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
  final _controller = Get.find<TabHistoryPresenter>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => ButtonCard(
        title: title,
        isChoose: _controller.indexTagHistory.value == index,
        voidcallback: () {
          _controller.selectTagHot(index);
          DefaultTabController.of(context).index = index;
        }));
  }
}

class _TabViewHistory extends StatelessWidget {
  _TabViewHistory();

  final _controller = Get.find<TabHistoryPresenter>();

  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          _controller.statusLoadMore.value == LoadStatus.succes) {
        _controller.loadMore();
      }
    });
    return Column(
      children: [
        Expanded(
          child: Obx(
            () => ListView.builder(
              controller: _scrollController,
              itemCount: _controller.listHistory.length +
                  (_controller.statusLoadMore.value == LoadStatus.max ? 0 : 1),
              itemBuilder: (context, index) {
                if (_controller.listHistory.length == index) {
                  return const LoadingWidget();
                } else {
                  return BookListItem(book: _controller.listHistory[index]);
                }
              },
            ),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              _controller.deleteHisttory();
            },
            child: const Text('Xóa lịch sử đọc'))
      ],
    );
  }
}

class _TabViewFavorite extends StatelessWidget {
  _TabViewFavorite();
  final _controller = Get.find<TabHistoryPresenter>();
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
                    onTap: () {
                      _controller
                          .deleteBookFavorite(_controller.listFavorite[index]);
                    },
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

class _TabViewDownload extends StatelessWidget {
  _TabViewDownload();
  final _controller = Get.find<TabHistoryPresenter>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: _controller.listDownload.length,
          itemBuilder: (context, index) => BookCard(
            book: _controller.listDownload[index],
            voidcallback: () {
              _controller.deleteBookDownload(_controller.listDownload[index]);
            },
          ),
        ),
      ),
    );
  }
}
