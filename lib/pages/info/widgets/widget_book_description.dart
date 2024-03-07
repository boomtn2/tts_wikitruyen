import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/model.dart';
import '../../../res/const_app.dart';
import '../../widgets/image_networkcustom.dart';
import '../../widgets/loading_widget.dart';
import '../book_info_controller.dart';

class BookDescriptionSection extends StatelessWidget {
  final String imgTag;
  final String titleTag;
  final String authorTag;
  final Book book;
  const BookDescriptionSection(
      {super.key,
      required this.imgTag,
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
              CategoryChips(),
            ],
          ),
        ),
      ],
    );
  }
}

class CategoryChips extends StatelessWidget {
  CategoryChips({super.key});
  final BookInfoController _controller = Get.find<BookInfoController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        children: [
          ..._controller.bookInfo.value.theLoai.entries.map((category) {
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
                    category.key,
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
