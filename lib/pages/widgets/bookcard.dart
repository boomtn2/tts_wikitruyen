import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/widgets/image_networkcustom.dart';
import 'package:tts_wikitruyen/res/const_app.dart';
import 'package:uuid/uuid.dart';

import '../../model/model.dart';
import '../../res/routers/app_router_name.dart';
import '../data_push.dart';
import 'loading_widget.dart';

class BookCard extends StatelessWidget {
  final Book book;

  BookCard({
    super.key,
    required this.book,
  });
  static const uuid = Uuid();
  final String imgTag = uuid.v4();
  final String titleTag = uuid.v4();
  final String authorTag = uuid.v4();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      onTap: () {
        DataPush.pushTagHero(
            {'imgTag': imgTag, 'titleTag': titleTag, 'authorTag': authorTag});
        DataPush.pushBook(book: book);
        DataPush.isStateOffline();
        Get.toNamed(AppRoutesName.bookInfo);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Banner(
              location: BannerLocation.bottomStart,
              message: 'Đã Tải',
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                child: Hero(
                    tag: imgTag,
                    child: ImageNetWorkCustom(
                        link: book.imgPath,
                        pathAssetImg: pathAssetsError,
                        widgetLoading: const LoadingWidget())),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              book.bookName,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
