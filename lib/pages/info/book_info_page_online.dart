import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data_push.dart';
import '../error/error_page.dart';
import '../widgets/itembooklist.dart';
import 'book_info_controller.dart';
import 'webview/webview_page.dart';
import 'widgets/c_divider.dart';
import 'widgets/desciption_widget.dart';
import 'widgets/i_view_chapter.dart';
import 'widgets/widget_book_description.dart';
import 'widgets/widget_section_title.dart';

class BookInfoPageOnline extends StatefulWidget {
  const BookInfoPageOnline({super.key});

  @override
  State<BookInfoPageOnline> createState() => _BookInfoPageOnlineState();
}

class _BookInfoPageOnlineState extends State<BookInfoPageOnline> {
  final _scrollListView = ScrollController();

  final BookInfoController _controller = Get.find<BookInfoController>();

  late String imgTag;

  late String titleTag;

  late String authorTag;
  @override
  void initState() {
    getTag();

    super.initState();
  }

  void getTag() {
    Map<String, String> tags = DataPush.getTagHero();
    imgTag = tags['imgTag'] ?? 'imgTag';
    titleTag = tags['titleTag'] ?? 'titleTag';
    authorTag = tags['authorTag'] ?? 'authorTag';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
        () => _controller.isError.value
            ? ErrorPage(
                error: _controller.messError,
                reload: () {
                  _controller.initOnline();
                })
            : ListView(
                controller: _scrollListView,
                children: [
                  _controller.isChapter.value
                      ? IViewChapter()
                      : Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const DividerC(),
                            BookDescriptionSection(
                              authorTag: authorTag,
                              imgTag: imgTag,
                              titleTag: titleTag,
                              book: _controller.book,
                            ),
                            const DividerC(),
                            const SectionTitle(title: 'Mô tả:'),
                            DescriptionTextWidget(
                                text: _controller.bookInfo.value.moTa),
                            const SectionTitle(title: 'Truyện Tương Tự:'),
                            ItemListBookSame(),
                          ],
                        ),
                  const DividerC(),
                  const SectionTitle(title: 'Chương:'),
                  WebViewPage(
                    controller: _controller.getControllerWV(),
                    fctCallBack: (titleChapter, linkChapter) {
                      _scrollListView.jumpTo(0);
                      _controller.selectedChapterOnline(
                          titleChapter, linkChapter);
                    },
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                ],
              ),
      ),
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
                    _controller.initOnline();
                  },
                  optionFull: false,
                );
              }),
        ),
      ),
    );
  }
}
