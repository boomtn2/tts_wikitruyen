import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../../presenters/presenters_export.dart';
import '../../../../widgets/bottomsheet_custom.dart';

class Buttontts extends StatelessWidget {
  Buttontts({super.key});
  final _controller = Get.find<BookInforPresenter>();
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
  final BookInforPresenter controller;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          switch (controller.uiPlayStatus.value) {
            case UIPlayStatus.pause:
              controller.pause();
              break;
            case UIPlayStatus.play:
              controller.play();
              break;
            case UIPlayStatus.loading:
              break;
            case UIPlayStatus.error:
              // Get.snackbar('Lỗi TTS:', controller.messError);
              break;
          }
        },
        child: Obx(
          () => SizedBox(
              height: 60,
              width: 60,
              child: widgetUIPlay(status: controller.uiPlayStatus.value)),
        ));
  }

  Widget widgetUIPlay({required UIPlayStatus status}) {
    switch (status) {
      case UIPlayStatus.pause:
        return const Card(
          color: Colors.blue,
          child: Icon(
            Icons.pause,
            size: 48,
            color: Colors.black,
          ),
        );
      case UIPlayStatus.play:
        return const Card(
          color: Colors.blue,
          child: Icon(
            Icons.play_arrow,
            color: Colors.black,
            size: 48,
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
            size: 48,
          ),
        );
    }
  }
}

class ButtonSelectVoices extends StatelessWidget {
  const ButtonSelectVoices({super.key, required this.controller});
  final BookInforPresenter controller;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          Get.bottomSheet(bottomSheetCustom(
            data: controller.ttsModel.value.getVoiceList(),
            function: (e) {
              controller.setVoice(e);
            },
            indexChoose: controller.ttsModel.value.getVoiceNow(),
          ));
        },
        child: Card(
          child: SizedBox(
              height: 48,
              child: Center(
                child: Text(
                  "Giọng đọc: \n${controller.ttsModel.value.getVoiceNow()}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
        ),
      ),
    );
  }
}

class ButtonSpeed extends StatelessWidget {
  const ButtonSpeed({super.key, required this.controller});
  final BookInforPresenter controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          Get.bottomSheet(bottomSheetCustom(
            data: controller.ttsModel.value.getSpeedData(),
            function: (e) {
              controller.setSpeed(e);
            },
            indexChoose: controller.ttsModel.value.getSpeedNow(),
          ));
        },
        child: Card(
            child: SizedBox(
                width: 48,
                height: 48,
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Tốc Độ ${controller.ttsModel.value.getSpeedNow()} ",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                )))),
      ),
    );
  }
}

class ButtonSkip extends StatelessWidget {
  const ButtonSkip({super.key, required this.controller});
  final BookInforPresenter controller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.skip();
      },
      child: const Card(
          child: Icon(
        Icons.skip_next,
        size: 40,
      )),
    );
  }
}
