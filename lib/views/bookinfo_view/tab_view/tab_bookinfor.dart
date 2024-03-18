import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../presenters/bookinfor_presenter/bookinfor_presenter.dart';
import '../widgets/widgets_export.dart';

class TabBookInfor extends StatelessWidget {
  TabBookInfor({super.key});
  final _controller = Get.find<BookInforPresenter>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _controller.bookInfoModel.value.book == null
                    ? const SizedBox.shrink()
                    : BookDescriptionSection(
                        authorTag: _controller.authorTag,
                        imgTag: _controller.imgTag,
                        titleTag: _controller.titleTag,
                        book: _controller.bookInfoModel.value.book!,
                      ),
                const DividerC(),
                const SectionTitle(title: 'Mô tả:'),
                DescriptionTextWidget(
                    text: _controller.bookInfoModel.value.moTa),
                const SectionTitle(title: 'Truyện Tương Tự:'),
                ItemListBookSame(),
              ],
            ),
          ),
          const DividerC(),
          const SectionTitle(title: 'Chương:'),
          Indexing(),
          Chapters(),
          const SizedBox(
            height: 200,
          ),
        ],
      ),
    );
  }
}
