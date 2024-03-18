import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tts_wikitruyen/presenters/home_presenter/tab_presenter/tab_youtube_presenter.dart';

import '../../../presenters/presenters_export.dart';
import '../../widgets/itembooklist.dart';
import '../../widgets/loading_widget.dart';

class TabYoutube extends StatelessWidget {
  TabYoutube({super.key});
  final _controller = Get.find<TabYoutubePresenter>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _controller.controllerLinkBook,
            decoration: InputDecoration(
                prefixIcon: ElevatedButton.icon(
                    onPressed: () {
                      _controller.searchLink();
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Đọc truyện')),
                border: const OutlineInputBorder(),
                hintText: 'Nhập đường dẫn truyện'),
          ),
        ),
        Expanded(
          child: _ListView(),
        ),
      ],
    );
  }
}

class _ListView extends StatelessWidget {
  _ListView();

  final _controller = Get.find<TabYoutubePresenter>();

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
    return Obx(
      () => ListView.builder(
        controller: _scrollController,
        itemCount: _controller.listBook.length +
            (_controller.statusLoadMore.value == LoadStatus.max ? 0 : 1),
        itemBuilder: (context, index) {
          if (_controller.listBook.length == index) {
            return const LoadingWidget();
          } else {
            return BookListItem(book: _controller.listBook[index]);
          }
        },
      ),
    );
  }
}
