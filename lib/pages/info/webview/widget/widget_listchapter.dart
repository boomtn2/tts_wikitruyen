import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/info/tts/tts_controller.dart';

import '../webview_controller.dart';

class WidgetListChapters extends StatelessWidget {
  WidgetListChapters(
      {super.key, required this.controller, required this.fctCallBack});
  final WVController controller;
  final Function(String titleChapter, String linkChapter) fctCallBack;
  final ControllerTTS _controllerTTS = ControllerTTS();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.listChuong.isEmpty
          ? ElevatedButton(
              onPressed: () {
                controller.reload();
              },
              child: const Icon(Icons.replay_outlined))
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
    return Builder(builder: (context) {
      return Obx(
        () => InkWell(
          onTap: () {
            fctCallBack(title, value);
          },
          child: Card(
            child: ListTile(
              title: Text(
                title,
                style: TextStyle(
                    color: value.contains(Uri.tryParse(
                                _controllerTTS.chapter.value.linkChapter)!
                            .path)
                        ? Colors.red
                        : null),
              ),
            ),
          ),
        ),
      );
    });
  }
}
