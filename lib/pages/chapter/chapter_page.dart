import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/chapter/chapter_controller.dart';
import 'package:tts_wikitruyen/pages/tts/widget_buttonTTS.dart';

import '../tts/enum_state.dart';

class ChapterPage extends StatefulWidget {
  const ChapterPage({
    super.key,
  });

  @override
  State<ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  final ChapterController _controller = Get.find<ChapterController>();
  @override
  void dispose() {
    _controller.controllerTTS.stopTTS();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text(_controller.getNameChapter()),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            _controller.chapter.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Nội dung chương rỗng!'),
                        const Divider(),
                        const Text('1. Kiểm Tra lại Kết Nối Mạng!'),
                        const Text('2. Lỗi đường dẫn truyện.'),
                        const Text('3. CHƯƠNG NÀY NÓ RỖNG THẬT :V'),
                        const Divider(),
                        Text(
                            'System ERROR [${_controller.controllerTTS.messError}]'),
                      ],
                    ),
                  )
                : Expanded(
                    child: Obx(
                      () => ListView.builder(
                          itemCount: _controller.chapter.length,
                          itemBuilder: (context, index) => Obx(
                                () => _controller.controllerTTS.index.value ==
                                        index
                                    ? RichText(
                                        text: TextSpan(
                                          text: _controller.chapter[index]
                                              .substring(
                                                  0,
                                                  _controller.controllerTTS
                                                      .start.value),
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: _controller.chapter[index]
                                                    .substring(
                                                        _controller
                                                            .controllerTTS
                                                            .start
                                                            .value,
                                                        _controller
                                                            .controllerTTS
                                                            .end
                                                            .value),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: _controller.chapter[index]
                                                    .substring(_controller
                                                        .controllerTTS
                                                        .end
                                                        .value)),
                                          ],
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          print('chọn $index');
                                        },
                                        child: Column(
                                          children: [
                                            Divider(
                                              color: Get.theme.primaryColor,
                                            ),
                                            Text(
                                              _controller.chapter[index],
                                            ),
                                          ],
                                        )),
                              )),
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => Visibility(
            visible: _controller.statusLoading.value == StatusLoading.succes,
            child: ButtonsTTS()),
      ),
    );
  }
}
