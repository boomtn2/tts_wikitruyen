import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/info/tts/tts_controller.dart';
import 'package:tts_wikitruyen/pages/widgets/loading_widget.dart';

import '../book_info_controller.dart';

class IViewChapter extends StatelessWidget {
  IViewChapter({super.key});
  final _controllerTTS = ControllerTTS();
  final _controller = Get.find<BookInfoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _controller.isModeOffline.value ? barOffline() : barOnline(),
            const Divider(),
            _controller.isLoadListChapter.value
                ? const LoadingWidget()
                : Text(_controllerTTS.dataListText.toString()),
          ],
        ),
      ),
    );
  }

  Widget barOffline() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox.shrink(),
        Expanded(
          child: Title(
              color: Colors.black,
              child: Text(
                _controllerTTS.chapter.value.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              )),
        ),
        IconButton(
          onPressed: () {
            _controllerTTS.skipTTS();
          },
          icon: const Icon(Icons.arrow_circle_right_outlined),
        ),
      ],
    );
  }

  Widget barOnline() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Uri.tryParse(_controllerTTS.chapter.value.linkPre) == null
            ? const SizedBox.shrink()
            : IconButton(
                onPressed: () {
                  _controllerTTS.preLoad();
                },
                icon: const Icon(Icons.arrow_circle_left_outlined),
              ),
        Expanded(
          child: Title(
              color: Colors.black,
              child: Text(
                _controllerTTS.chapter.value.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              )),
        ),
        Uri.tryParse(_controllerTTS.chapter.value.linkNext) == null
            ? const SizedBox.shrink()
            : IconButton(
                onPressed: () {
                  _controllerTTS.skipTTS();
                },
                icon: const Icon(Icons.arrow_circle_right_outlined),
              ),
      ],
    );
  }
}
