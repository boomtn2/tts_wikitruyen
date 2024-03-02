import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/error/error_page.dart';

import 'package:tts_wikitruyen/pages/info/book_info_controller.dart';
import 'package:tts_wikitruyen/pages/widgets/image_networkcustom.dart';

import 'package:tts_wikitruyen/pages/widgets/itembooklist.dart';
import 'package:tts_wikitruyen/res/const_app.dart';

import '../../models/book.dart';
import '../tts/enum_state.dart';
import '../tts/widget_buttonTTS.dart';

import '../widgets/desciption_widget.dart';
import '../widgets/loading_widget.dart';

class BookInfoPage extends StatefulWidget {
  const BookInfoPage({
    Key? key,
    required this.imgTag,
    required this.titleTag,
    required this.authorTag,
  }) : super(key: key);
  final String imgTag;
  final String titleTag;
  final String authorTag;
  @override
  State<BookInfoPage> createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  final BookInfoController _controller = Get.find<BookInfoController>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.controllerTTS.stopTTS();
    _controller.saveHistoryBook();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.9)) {
      if (_controller.isLoadListChapter.value == false) {
        _controller.loadMoreChapter();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            const Icon(Icons.favorite),
            const Icon(Icons.download),
            InkWell(
                onTap: () {
                  Get.changeThemeMode(ThemeMode.dark);
                },
                child: const Icon(Icons.settings)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => _controller.isError.value
                ? ErrorPage(
                    error: _controller.messError,
                    reload: () {
                      _controller.init();
                    })
                : ListView(
                    controller: _scrollController,
                    children: [
                      const _Divider(),
                      _BookDescriptionSection(
                        authorTag: widget.authorTag,
                        imgTag: widget.imgTag,
                        titleTag: widget.titleTag,
                        book: _controller.book,
                      ),
                      const _Divider(),
                      const _SectionTitle(title: 'Mô tả:'),
                      DescriptionTextWidget(
                          text: _controller.bookInfo.value.moTa),
                      const _SectionTitle(title: 'Truyện Tương Tự:'),
                      ItemListBookSame(),
                      const _Divider(),
                      const _SectionTitle(title: 'Chương:'),
                      ListChapters(),
                      _controller.isLoadListChapter.value
                          ? const LoadingWidget()
                          : Container(),
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
          ),
        ),
        bottomSheet: Obx(() => Visibility(
            visible: _controller.statusLoading.value == StatusLoading.succes,
            child: ButtonsTTS())));
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class ItemListBookSame extends StatelessWidget {
  ItemListBookSame({super.key});
  final _controller = Get.find<BookInfoController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        child: SizedBox(
          height: Get.height / 5,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _controller.listBookSame.length,
              itemBuilder: (context, index) {
                return BookListItem(
                  book: _controller.listBookSame[index],
                  funtionOption: () {
                    _controller.book = _controller.listBookSame[index];
                    _controller.init();
                  },
                  optionFull: false,
                );
              }),
        ),
      ),
    );
  }
}

class ListChapters extends StatelessWidget {
  ListChapters({super.key});
  final _controller = Get.find<BookInfoController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Obx(
          () => Card(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(children: [
                for (int i = 0;
                    i <
                        (_controller.bookInfo.value.dsChuong.length >
                                _controller.maxItemScroll.value
                            ? _controller.maxItemScroll.value
                            : _controller.bookInfo.value.dsChuong.length);
                    ++i)
                  InkWell(
                    onTap: () {
                      _controller.nextToChapterPage(
                          choose: _controller.bookInfo.value.dsChuong[i]);
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(
                            "${_controller.bookInfo.value.dsChuong[i].keys}"),
                      ),
                    ),
                  )
              ]),
            ),
          ),
        ),
      ],
    );
  }
}

class _BookDescriptionSection extends StatelessWidget {
  final String imgTag;
  final String titleTag;
  final String authorTag;
  final Book book;
  const _BookDescriptionSection(
      {required this.imgTag,
      required this.titleTag,
      required this.authorTag,
      required this.book});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Hero(
            tag: imgTag,
            child: ImageNetWorkCustom(
              link: book.imgPath,
              pathAssetImg: pathAssetsError,
              widgetLoading: const LoadingWidget(
                isImage: true,
              ),
              height: 200,
              width: 130,
            )),
        const SizedBox(width: 20.0),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 5.0),
              Hero(
                tag: titleTag,
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    book.bookName,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3,
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              Hero(
                tag: authorTag,
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    book.bookAuthor,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              _CategoryChips(),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryChips extends StatelessWidget {
  _CategoryChips();
  final BookInfoController _controller = Get.find<BookInfoController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        children: [
          ..._controller.bookInfo.value.theLoai.map((category) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: context.theme.colorScheme.secondary,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7.0,
                    vertical: 5,
                  ),
                  child: Text(
                    category.entries.first.key,
                    style: TextStyle(
                      color: context.theme.colorScheme.secondary,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(color: context.theme.textTheme.bodySmall!.color);
  }
}
