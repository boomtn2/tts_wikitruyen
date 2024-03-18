import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:tts_wikitruyen/views/bookinfo_view/widgets/widgets_export.dart';

import '../../../presenters/presenters_export.dart';
import 'tab_audio/widgets/widget_button_tts.dart';

class TabReadBook extends StatelessWidget {
  TabReadBook({super.key});
  final _controller = Get.find<BookInforPresenter>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          SizedBox(
              height: 60,
              child: ListTile(
                title: Text(
                  _controller.chapter.value.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Get.bottomSheet(SizedBox(
                            height: Get.size.height / 2,
                            child: Column(
                              children: [
                                Indexing(),
                                Expanded(
                                  child: ListView(
                                    children: [Chapters()],
                                  ),
                                )
                              ],
                            ),
                          ));
                        },
                        child: const SizedBox(
                          height: 40,
                          child: Icon(Icons.menu),
                        )),
                    ButtonSkip(
                      controller: _controller,
                    ),
                  ],
                ),
              )),
          const DividerC(),
          Expanded(
            child: ListView(children: [
              rickTextCustom(_controller.chapter.value.text, context, 0),
              const DividerC(),
              Indexing(),
              Chapters()
            ]),
          ),
        ],
      );
    });
  }

  Widget rickTextCustom(String text, BuildContext context, int index) {
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        children: _generateTextSpans(text, context, index),
      ),
    );
  }

  List<TextSpan> _generateTextSpans(
      String text, BuildContext context, int index) {
    List<TextSpan> spans = [];
    final List<String> words =
        _controller.ttsModel.value.splitTextIntoSentences(text);

    for (var word in words) {
      spans.add(
        TextSpan(
          text: '$word.\n\n',
          style: context.textTheme.titleLarge,
        ),
      );
    }

    return spans;
  }
}
