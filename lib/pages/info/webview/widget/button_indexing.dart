import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../webview_controller.dart';

class ButtonIndexing extends StatelessWidget {
  const ButtonIndexing({
    super.key,
    required this.wvController,
  });
  final WVController wvController;
  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
        children: wvController.chiMuc.entries
            .map((e) => SizedBox(
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () {
                        wvController.selectChiMuc(stChimuc: e.key);
                      },
                      child: Text(
                        e.key,
                        style: TextStyle(
                            color: 'active'.compareTo(e.value.trim()) == 0
                                ? Colors.red
                                : Colors.black),
                      )),
                ))
            .toList()));
  }
}
