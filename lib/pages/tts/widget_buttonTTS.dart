
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/tts/tts_controller.dart';

import '../widgets/bottomsheet_custom.dart';

class ButtonsTTS extends StatelessWidget {
  ButtonsTTS({super.key});
  final _controller = ControllerTTS();
  @override
  Widget build(BuildContext context) {
    return   Container(
      padding: const EdgeInsets.all(8.0),
      height: 65,
      color: Colors.black,
      child:   Row(
          children: [
            ButtonPlay(controller: _controller,),
           ButtonSelectChapter(controller: _controller),
            Expanded(
              child:  ButtonSelectVoices(controller: _controller,),
            ),
           ButtonSpeed(controller: _controller,),
          ButtonSkip(controller: _controller,),
          ],
        ),
       
    );
  }
}

class ButtonPlay extends StatelessWidget {
    ButtonPlay({super.key, required this.controller });
     ControllerTTS controller;
  @override
  Widget build(BuildContext context) {
    return  Obx(
      ()=> InkWell(
                    onTap: () {
                      controller.isPlay.value
                          ? controller.pauseTTS()
                          : controller.playTTS();
                    },
                    child: Card(
                        color: Colors.blue,
                        child: Icon(
                          controller.isPlay.value
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 40,
                        )),
                  ),
    );
  }
}


class ButtonSelectChapter extends StatelessWidget {
    ButtonSelectChapter({super.key, required this.controller});
ControllerTTS controller;
  @override
  Widget build(BuildContext context) {
    return   Obx(
      ()=> InkWell(
                    onTap: () {
                      Get.bottomSheet(bottomSheetChapter(
                          indexChoose: "",
                          data: controller.pathChapters,
                          function: (e) {
                            int index = controller.getIndexChapterInList(choose: e);
                            controller.loadNewChapter( indexPath:index );
                          }));
                    },
                    child: SizedBox(
                      width: Get.width / 3,
                      child: Card(
                        child: Center(
                            child:
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("${controller.titleNow}",style: TextStyle(fontSize: 10),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                )),
                      ),
                    ),
                  ),
    );
  }
}

class ButtonSelectVoices extends StatelessWidget {
     
 ButtonSelectVoices({super.key, required this.controller});
ControllerTTS controller;
  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> InkWell(
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
                        child: Center(child: Text("Giọng đọc: \n${controller.voiceNow.values}",textAlign: TextAlign.center, style: TextStyle(fontSize: 10),maxLines: 2,overflow: TextOverflow.ellipsis,)),
                      ),
                    ),
    );
  }
}

class ButtonSpeed extends StatelessWidget {
 ButtonSpeed({super.key, required this.controller});
ControllerTTS controller;

  @override
  Widget build(BuildContext context) {
    return  Obx(
      ()=> InkWell(
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
                                    "Tốc Độ ${controller.speedNow} ",textAlign: TextAlign.center, style: TextStyle(fontSize: 10,),)))),
                  ),
    );
  }
}

class ButtonSkip extends StatelessWidget {
 ButtonSkip({super.key, required this.controller});
ControllerTTS controller;

  @override
  Widget build(BuildContext context) {
    return InkWell(
                    onTap: () {
                      controller.skipTTS();
                    },
                    child: Card(
                        child: Icon(
                      Icons.skip_next,
                      size: 40,
                    )),
                   
    );
  }
}