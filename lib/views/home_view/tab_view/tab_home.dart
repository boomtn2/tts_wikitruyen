import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tts_wikitruyen/presenters/home_presenter/tab_presenter/export.dart';

import '../../../untils/themes_until/theme_config.dart';

import '../../widgets/itembooklist.dart';
import '../../widgets/loading_widget.dart';

import '../widgets/button_card.dart';

class TabHome extends StatelessWidget {
  TabHome({super.key});
  final _controller = Get.find<TabHomePresenter>();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _ListWebsiteButton(),
        _GenreSection(),
        Obx(() => _controller.statusLoadList.value == LoadStatus.loading
            ? const LoadingWidget()
            : Expanded(child: _ListItemBook())),
      ],
    );
  }
}

class _ListItemBook extends StatelessWidget {
  _ListItemBook({super.key});
  final _controller = Get.find<TabHomePresenter>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
          itemCount: _controller.listBooks.length,
          itemBuilder: (context, index) {
            if (index == _controller.listBooks.length - 1 &&
                _controller.statusLoadMore.value == LoadStatus.succes) {
              _controller.loadMoreBooks();
              return Obx(() =>
                  _controller.statusLoadMore.value == LoadStatus.loading
                      ? const LoadingWidget()
                      : const SizedBox.shrink());
            }
            return BookListItem(book: _controller.listBooks[index]);
          }),
    );
  }
}

class _ListWebsiteButton extends StatelessWidget {
  _ListWebsiteButton();
  final _controller = Get.find<TabHomePresenter>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: 40,
        width: Get.size.width,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _controller.listWebsite.length,
            itemBuilder: (context, index) => Obx(
                  () => ButtonCard(
                    title: _controller.listWebsite[index].website,
                    isChoose: _controller.currentWebsite.value.website ==
                        _controller.listWebsite[index].website,
                    voidcallback: () {
                      _controller.selectWebsite(_controller.listWebsite[index]);
                    },
                  ),
                )),
      ),
    );
  }
}

class _GenreSection extends StatelessWidget {
  _GenreSection();
  final _controller = Get.find<TabHomePresenter>();
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
            itemCount: _controller.listTaghots.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 10.0,
                ),
                child: Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      color: _controller.currenTaghot.value == index
                          ? ThemeUntil.colorChosseTag
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
                        _controller.selectTagHot(index);
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            _controller.listTaghots[index].nametag,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
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
