import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:tts_wikitruyen/pages/info/tts/tts_controller.dart';

import '../../widgets/bottomsheet_custom.dart';

class ButtonsTTS extends StatelessWidget {
  ButtonsTTS({super.key});
  final _controller = ControllerTTS();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 65,
      color: Colors.black,
      child: Row(
        children: [
          ButtonPlay(
            controller: _controller,
          ),
          ButtonSelectChapter(controller: _controller),
          Expanded(
            child: ButtonSelectVoices(
              controller: _controller,
            ),
          ),
          ButtonSpeed(
            controller: _controller,
          ),
          ButtonSkip(
            controller: _controller,
          ),
        ],
      ),
    );
  }
}

class ButtonPlay extends StatelessWidget {
  const ButtonPlay({super.key, required this.controller});
  final ControllerTTS controller;
  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
          onTap: () {
            switch (controller.uiPlayStatus.value) {
              case UIPlayStatus.pause:
                controller.pauseTTS();
                break;
              case UIPlayStatus.play:
                controller.playTTS();
                break;
              case UIPlayStatus.loading:
                break;
              case UIPlayStatus.error:
                Get.snackbar('Lỗi TTS:', controller.messError);
                break;
            }
          },
          child: widgetUIPlay(status: controller.uiPlayStatus.value),
        ));
  }

  Widget widgetUIPlay({required UIPlayStatus status}) {
    switch (status) {
      case UIPlayStatus.pause:
        return const Card(
          color: Colors.blue,
          child: Icon(Icons.pause, size: 40),
        );
      case UIPlayStatus.play:
        return const Card(
          color: Colors.blue,
          child: Icon(
            Icons.play_arrow,
            size: 40,
          ),
        );
      case UIPlayStatus.loading:
        return const Card(
          color: Colors.grey,
          child: CircularProgressIndicator(color: Colors.red, strokeAlign: -1),
        );
      case UIPlayStatus.error:
        return const Card(
          color: Colors.red,
          child: Icon(
            Icons.error,
            size: 40,
          ),
        );
    }
  }
}

class ButtonSelectChapter extends StatelessWidget {
  const ButtonSelectChapter({super.key, required this.controller});
  final ControllerTTS controller;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {},
        child: SizedBox(
          width: Get.width / 3,
          child: Card(
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                controller.chapter.value.title,
                style: const TextStyle(fontSize: 10),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )),
          ),
        ),
      ),
    );
  }
}

class ButtonSelectVoices extends StatelessWidget {
  const ButtonSelectVoices({super.key, required this.controller});
  final ControllerTTS controller;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          Get.bottomSheet(bottomSheetCustom(
            data: controller.voiceList,
            function: (e) {
              controller.setVoice(voice: e);
            },
            indexChoose: controller.voiceNow,
          ));
        },
        child: Card(
          child: Center(
              child: Text(
            "Giọng đọc: \n${controller.voiceNow.values}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )),
        ),
      ),
    );
  }
}

class ButtonSpeed extends StatelessWidget {
  const ButtonSpeed({super.key, required this.controller});
  final ControllerTTS controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          Get.bottomSheet(bottomSheetCustom(
            data: controller.speedData,
            function: (e) {
              controller.setSpeedRate(speedRate: e);
            },
            indexChoose: controller.speedNow.value,
          ));
        },
        child: Card(
            child: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                    child: Text(
                  "Tốc Độ ${controller.speedNow} ",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                )))),
      ),
    );
  }
}

class ButtonSkip extends StatelessWidget {
  const ButtonSkip({super.key, required this.controller});
  final ControllerTTS controller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.skipTTS();
      },
      child: const Card(
          child: Icon(
        Icons.skip_next,
        size: 40,
      )),
    );
  }
}
