import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/repositories/data_push.dart';
import 'package:tts_wikitruyen/untils/path_until/img_path_until.dart';
import 'package:tts_wikitruyen/untils/routers_until/app_router_name.dart';

import 'package:uuid/uuid.dart';

import '../../models/models_export.dart';
import 'image_networkcustom.dart';
import 'loading_widget.dart';

// ignore: must_be_immutable
class BookListItem extends StatelessWidget {
  BookListItem({
    Key? key,
    required this.book,
    this.funtionOption,
    this.optionFull = true,
  }) : super(key: key);
  final BookModel book;
  static const uuid = Uuid();
  final String imgTag = uuid.v4();
  final String titleTag = uuid.v4();
  final String authorTag = uuid.v4();
  final Function? funtionOption;
  bool optionFull = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: funtionOption == null
            ? () {
                DataPush.pushTagHero({
                  'imgTag': imgTag,
                  'titleTag': titleTag,
                  'authorTag': authorTag
                });
                DataPush.pushBook(book: book);
                DataPush.isStateOnline();
                Get.toNamed(AppRoutesName.bookInfo);
              }
            : () {
                funtionOption!();
              },
        child: optionFull ? itemFull(context) : itemSmarll(context));
  }

  Widget itemFull(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 150.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              elevation: 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: Hero(
                  tag: imgTag,
                  child: ImageNetWorkCustom(
                      link: book.imgPath,
                      pathAssetImg: pathAssetsError,
                      widgetLoading: const LoadingWidget(
                        isImage: true,
                      )),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: titleTag,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        book.bookName,
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: context.theme.textTheme.titleLarge!.color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Hero(
                    tag: authorTag,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        book.bookAuthor,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w800,
                          color: context.theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    book.history == null
                        ? book.bookViews
                        : book.history!.nameChapter.trim(),
                    maxLines: book.history == null ? 1 : 2,
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Get.theme.textTheme.bodySmall!.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemSmarll(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100.0,
        width: context.width / 1.5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              elevation: 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: Hero(
                  tag: imgTag,
                  //120 75
                  child: ImageNetWorkCustom(
                      height: 120,
                      width: 75,
                      link: book.imgPath,
                      pathAssetImg: pathAssetsError,
                      widgetLoading: const LoadingWidget(
                        isImage: true,
                      )),
                ),
              ),
            ),
            const SizedBox(width: 5.0),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: titleTag,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        book.bookName,
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: context.theme.textTheme.titleLarge!.color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Hero(
                    tag: authorTag,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        book.bookAuthor,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w800,
                          color: context.theme.colorScheme.secondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    book.bookViews,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Get.theme.textTheme.bodySmall!.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
