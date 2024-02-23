import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/routers/app_router_name.dart';
import '../../widgets/item_book.dart';
import '../search_controller.dart';

class ReponseSearchPage extends StatelessWidget {
  ReponseSearchPage({super.key});
  final _controller = Get.find<SearchPageController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                ))
              : Expanded(
                  child: ListView.builder(
                      itemCount: _controller.listBooks.length,
                      itemBuilder: (context, index) {
                        if (index == _controller.listBooks.length - 1 &&
                            _controller.isLoadMore.value == false) {
                          _controller.loadMoreItems();
                          return Center(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                          ));
                        }
                        return ItemBook(
                          book: _controller.listBooks[index],
                          nexToPage: () {
                            Get.lazyPut(() => _controller.listBooks[index],
                                tag: 'Page BookInfo');

                            Get.toNamed(AppRoutesName.bookInfo);
                          },
                        );
                      }),
                ),
        ],
      ),
    );
  }
}
