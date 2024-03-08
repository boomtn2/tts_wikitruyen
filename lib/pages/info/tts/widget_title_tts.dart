import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tts_controller.dart';

class WidgetTitleTTS extends StatelessWidget {
  WidgetTitleTTS({super.key, required this.isModeOffline});
  final bool isModeOffline;
  final _controllerTTS = ControllerTTS();
  @override
  Widget build(BuildContext context) {
    return isModeOffline ? barOffline() : barOnline();
  }

  Widget barOffline() {
    return Obx(
      () => Row(
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
      ),
    );
  }

  Widget barOnline() {
    return Obx(
      () => Row(
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
      ),
    );
  }
}
