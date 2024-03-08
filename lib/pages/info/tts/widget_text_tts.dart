import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tts_controller.dart';

class WidgetTextTTS extends StatelessWidget {
  WidgetTextTTS({super.key});
  final _controllerTTS = ControllerTTS();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int index = -1;
      return Column(
          mainAxisSize: MainAxisSize.max,
          children: _controllerTTS.dataListText
              .map((element) => rickTextCustom(element, context, ++index))
              .toList());
    });
  }

  Widget rickTextCustom(String text, BuildContext context, int index) {
    return RichText(
      text: TextSpan(
        children: _generateTextSpans(text, context, index),
      ),
    );
  }

  List<TextSpan> _generateTextSpans(
      String text, BuildContext context, int index) {
    List<TextSpan> spans = [];
    final List<String> words = text.split('.');

    for (var word in words) {
      spans.add(
        TextSpan(
          text: word + '.\n\n',
          recognizer: LongPressGestureRecognizer()
            ..onLongPress = () {
              _controllerTTS.selectString(word + '.', index);

              Get.snackbar('Vị trí nghe:', word);
            },
          style: context.textTheme.labelLarge,
        ),
      );
    }

    return spans;
  }
}
