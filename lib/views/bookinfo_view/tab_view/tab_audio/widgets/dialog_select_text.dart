import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../../presenters/presenters_export.dart';

class DialogSelectText extends StatelessWidget {
  DialogSelectText({super.key});
  final controller = Get.find<BookInforPresenter>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bấm Giữ Đoạn Cần Nghe',
          style: TextStyle(color: Colors.red),
        ),
      ),
      body: Obx(() {
        int index = -1;
        return ListView(
            children: controller.ttsModel.value
                .getDataList()
                .map((element) => rickTextCustom(element, context, ++index))
                .toList());
      }),
    );
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
          text: '$word.\n\n',
          recognizer: LongPressGestureRecognizer()
            ..onLongPress = () {
              controller.selectString('$word.', index);
              Get.back();
              Get.snackbar('Vị trí nghe:', word);
            },
          style: context.textTheme.titleLarge,
        ),
      );
    }

    return spans;
  }
}
