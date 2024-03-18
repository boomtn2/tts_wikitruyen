import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../presenters/bookinfor_presenter/bookinfor_presenter.dart';

class Indexing extends StatelessWidget {
  Indexing({super.key});
  final _controller = Get.find<BookInforPresenter>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => Center(
          child: Wrap(
              children: _controller.chiMuc.entries
                  .map((e) => SizedBox(
                        height: 40,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    'active'.compareTo(e.value.trim()) == 0
                                        ? Colors.amber
                                        : Colors.blueGrey)),
                            onPressed: () {
                              _controller.selectChiMuc(e.key);
                            },
                            child: Text(
                              e.key,
                              style: TextStyle(
                                  color: 'active'.compareTo(e.value.trim()) == 0
                                      ? Colors.red
                                      : Colors.black),
                            )),
                      ))
                  .toList()),
        ));
  }
}
