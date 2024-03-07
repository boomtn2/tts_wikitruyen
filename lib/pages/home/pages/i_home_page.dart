import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/theme/theme_config.dart';
import '../../error/error_page.dart';
import '../../widgets/itembooklist.dart';
import '../../widgets/loading_widget.dart';
import '../home_controller.dart';

class BodyHome extends StatelessWidget {
  BodyHome({super.key});
  final _controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _controller.isError.value
          ? ErrorPage(
              reload: () {
                _controller.init();
              },
              error:
                  _controller.errorNetWork?.description ?? 'Lỗi Không xác định',
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                    height: 40,
                    width: Get.size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            _controller.listWebsite.value.listWebsite.length,
                        itemBuilder: (context, index) => websites(
                              _controller
                                  .listWebsite.value.listWebsite[index].website,
                              index,
                            ))),
                _GenreSection(),
                _controller.isLoading.value
                    ? const LoadingWidget()
                    : Expanded(
                        child: ListView.builder(
                            itemCount: _controller.listBooks.length,
                            itemBuilder: (context, index) {
                              if (index == _controller.listBooks.length - 1 &&
                                  _controller.isLoadMore.value == false &&
                                  _controller.isLoading.value == false) {
                                _controller.loadMoreItems();
                                return const LoadingWidget();
                              }

                              return BookListItem(
                                  book: _controller.listBooks[index]);
                            }),
                      ),
              ],
            ),
    );
  }

  Widget websites(String title, int index) {
    return Obx(
      () => InkWell(
        onTap: () {
          _controller.selectWebsite(index);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 5),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: _controller.websiteNow.value.website ==
                      _controller.listWebsite.value.listWebsite[index].website
                  ? Colors.white
                  : Colors.black,
              border: Border.all(
                color: _controller.websiteNow.value.website ==
                        _controller.listWebsite.value.listWebsite[index].website
                    ? Colors.blue
                    : Colors.white30,
                width: _controller.indexTagHistory.value == index ? 1 : 2,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: _controller.websiteNow.value.website ==
                          _controller
                              .listWebsite.value.listWebsite[index].website
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

class _GenreSection extends StatelessWidget {
  _GenreSection();
  final _controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: Obx(
        () => Center(
          child: ListView.builder(
            primary: false,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            scrollDirection: Axis.horizontal,
            itemCount: _controller.listTaghot.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              // We don't need the tags from 0-9 because
              // they are not categories

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 10.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: _controller.indexHotTag.value == index
                        ? colorChosseTag
                        : context.theme.colorScheme.secondary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  child: InkWell(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    onTap: () {
                      _controller.selectTag(indexTag: index);
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          _controller.listTaghot[index].nametag,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
