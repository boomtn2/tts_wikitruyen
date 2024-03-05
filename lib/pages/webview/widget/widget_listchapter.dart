import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/models/bookinfor.dart';
import 'package:tts_wikitruyen/res/routers/app_router_name.dart';

import '../webview_controller.dart';

class WidgetListChapters extends StatelessWidget {
  const WidgetListChapters({super.key, required this.controller});
  final WVController controller;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.listChuong.isEmpty
          ? ElevatedButton(
              onPressed: () {
                controller.reload();
              },
              child: Icon(Icons.replay_outlined))
          : Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                    children: controller.listChuong.entries
                        .map((e) => buttonChapter(e.value, e.key))
                        .toList()),
              ),
            ),
    );
  }

  Widget buttonChapter(String title, String value) {
    return InkWell(
      onTap: () {
        final BookInfo bookInfo = controller.getBookInfo();
        int index = bookInfo.getIndexChapterInList(choose: {title: value});

        Get.lazyPut(() => index, tag: 'index chapter');
        Get.lazyPut(() => bookInfo.dsChuong, tag: 'listChapter');
        Get.toNamed(AppRoutesName.chapter);
      },
      child: Card(
        child: ListTile(
          title: Text(title),
        ),
      ),
    );
  }
}
