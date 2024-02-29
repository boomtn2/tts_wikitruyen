import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/chapter/chapter_controller.dart';
import 'package:tts_wikitruyen/pages/tts/widget_buttonTTS.dart';

import '../widgets/bottomsheet_custom.dart';
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
            
          ],
        ),
      ),
 
      bottomNavigationBar: Obx(
        () => Visibility(
          visible: _controller.statusLoading.value == StatusLoading.SUCCES,
          child: ButtonsTTS()
        ),
      ),
      
    );
  }
}
