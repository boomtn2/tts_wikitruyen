import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/presenters/search_presenter/search_presenter.dart';
import 'package:tts_wikitruyen/views/widgets/itembooklist.dart';
import 'package:tts_wikitruyen/views/widgets/loading_widget.dart';

import 'widget_tags_slectected.dart';

class ReponseSearchPage extends StatelessWidget {
  ReponseSearchPage({super.key});
  final _controller = Get.find<SearchPresenter>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: () {
                DefaultTabController.of(context).index = 0;
              },
              child: const Icon(Icons.search)),
          TagsSelected(),
          _controller.isLoading.value
              ? const LoadingWidget()
              : Expanded(
                  child: ListView.builder(
                      itemCount: _controller.listBooks.length,
                      itemBuilder: (context, index) {
                        if (index == _controller.listBooks.length - 1 &&
                            _controller.isLoadMore.value == false) {
                          _controller.loadMoreItems();
                          return const LoadingWidget();
                        }
                        return BookListItem(
                          book: _controller.listBooks[index],
                        );
                      }),
                ),
        ],
      ),
    );
  }
}
