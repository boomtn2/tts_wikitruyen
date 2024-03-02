import 'package:flutter/material.dart';
import 'package:tts_wikitruyen/pages/widgets/image_networkcustom.dart';
import 'package:tts_wikitruyen/res/const_app.dart';
import 'package:uuid/uuid.dart';

import 'loading_widget.dart';

class BookCard extends StatelessWidget {
  final String img;

  BookCard({
    super.key,
    required this.img,
  });
  static const uuid = Uuid();
  final String imgTag = uuid.v4();
  final String titleTag = uuid.v4();
  final String authorTag = uuid.v4();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.0,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        elevation: 4.0,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          onTap: () {},
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            child: Hero(
                tag: imgTag,
                child: ImageNetWorkCustom(
                    link: img,
                    pathAssetImg: pathAssetsError,
                    widgetLoading: const LoadingWidget())),
          ),
        ),
      ),
    );
  }
}
