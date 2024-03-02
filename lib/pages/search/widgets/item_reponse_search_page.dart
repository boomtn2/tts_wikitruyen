import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/widgets/itembooklist.dart';
import 'package:tts_wikitruyen/pages/widgets/loading_widget.dart';

import '../search_controller.dart';
import 'widget_tags_slectected.dart';

class ReponseSearchPage extends StatelessWidget {
  ReponseSearchPage({super.key});
  final _controller = Get.find<SearchPageController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.max,
        children: [
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
