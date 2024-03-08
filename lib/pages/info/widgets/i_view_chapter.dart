import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:tts_wikitruyen/pages/widgets/loading_widget.dart';

import '../book_info_controller.dart';
import '../tts/widget_text_tts.dart';
import '../tts/widget_title_tts.dart';

class IViewChapter extends StatelessWidget {
  IViewChapter({super.key});

  final _controller = Get.find<BookInfoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WidgetTitleTTS(
              isModeOffline: _controller.isModeOffline.value,
            ),
            const Divider(),
            _controller.isLoadListChapter.value
                ? const LoadingWidget()
                : WidgetTextTTS(),
          ],
        ),
      ),
    );
  }
}
