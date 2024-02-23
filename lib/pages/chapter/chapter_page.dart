import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/chapter/chapter_controller.dart';

import '../info/widgets/bottomsheet_custom.dart';
import '../tts/enum_state.dart';

class ChapterPage extends StatefulWidget {
  ChapterPage({
    super.key,
  });

  @override
  State<ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  ChapterController _controller = Get.find<ChapterController>();
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.controllerTTS.stopTTS();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text('${_controller.getNameChapter()}'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                    itemCount: _controller.chapter.length,
                    itemBuilder: (context, index) => Obx(
                          () => _controller.controllerTTS.index.value == index
                              ? RichText(
                                  text: TextSpan(
                                    text:
                                        "${_controller.chapter[index].substring(0, _controller.controllerTTS.start.value)}",
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              "${_controller.chapter[index].substring(_controller.controllerTTS.start.value, _controller.controllerTTS.end.value)}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text:
                                              "${_controller.chapter[index].substring(_controller.controllerTTS.end.value)}"),
                                    ],
                                  ),
                                )
                              : Text(_controller.chapter[index]),
                        )),
              ),
            ),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
      bottomSheet: Obx(
        () => Visibility(
          visible: _controller.statusLoading.value == StatusLoading.SUCCES,
          child: Card(
            color: Colors.brown,
            child: SizedBox(
              height: 50,
              child: Obx(
                () => Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _controller.controllerTTS.isPlay.value
                            ? _controller.controllerTTS.pauseTTS()
                            : _controller.controllerTTS.playTTS();
                      },
                      child: Card(
                          color: Colors.blue,
                          child: Icon(
                            _controller.controllerTTS.isPlay.value
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 40,
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Get.bottomSheet(bottomSheetChapter(
                            indexChoose: _controller.controllerTTS.titleNow,
                            data: _controller.listChapter,
                            function: (e) {
                              _controller.setChapter(choose: e);
                            }));
                      },
                      child: SizedBox(
                        width: Get.width / 3,
                        child: Card(
                          child: Center(
                              child: Text(
                                  "${_controller.controllerTTS.titleNow}")),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.bottomSheet(bottomSheetCustom(
                            data: _controller.controllerTTS.voiceList,
                            function: (e) {
                              _controller.controllerTTS.setVoice(voice: e);
                            },
                            indexChoose: _controller.controllerTTS.voiceNow,
                          ));
                        },
                        child: Card(
                          child: Center(child: Text("Voice")),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.bottomSheet(bottomSheetCustom(
                          data: _controller.controllerTTS.speedData,
                          function: (e) {
                            _controller.controllerTTS
                                .setSpeedRate(speedRate: e);
                          },
                          indexChoose: 0.5,
                        ));
                      },
                      child: Card(
                          child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Center(
                                  child: Text(
                                      " X ${_controller.controllerTTS.speedNow} ")))),
                    ),
                    InkWell(
                      onTap: () {
                        _controller.controllerTTS.skipTTS();
                      },
                      child: Card(
                          child: Icon(
                        Icons.skip_next,
                        size: 40,
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
