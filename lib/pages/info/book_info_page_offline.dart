import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data_push.dart';

import 'book_info_controller.dart';

import 'widgets/c_divider.dart';
import 'widgets/desciption_widget.dart';
import 'widgets/i_view_chapter.dart';
import 'widgets/widget_book_description.dart';
import 'widgets/widget_section_title.dart';

class BookInfoPageOffline extends StatefulWidget {
  const BookInfoPageOffline({super.key});

  @override
  State<BookInfoPageOffline> createState() => _BookInfoPageOfflineState();
}

class _BookInfoPageOfflineState extends State<BookInfoPageOffline> {
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
        () => ListView(
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
                    ],
                  ),
            const DividerC(),
            const SectionTitle(title: 'Chương:'),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: _controller.bookInfo.value.dsChuong.entries
                  .map((e) => InkWell(
                      onTap: () {
                        _scrollListView.jumpTo(0);
                        _controller.selectedChapterOffline(e.value, e.key);
                      },
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(e.key),
                      ))))
                  .toList(),
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
