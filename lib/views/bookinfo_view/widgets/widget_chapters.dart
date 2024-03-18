import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../presenters/bookinfor_presenter/bookinfor_presenter.dart';

class Chapters extends StatelessWidget {
  Chapters({super.key});
  final _controller = Get.find<BookInforPresenter>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
              children: _controller.chapters.entries
                  .map((e) => buttonChapter(e.value, e.key))
                  .toList()),
        ),
      ),
    );
  }

  Widget buttonChapter(String title, String value) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () {
          _controller.setChapter(title, value);
          if (_controller.currentIndexTab.value == 0) {
            DefaultTabController.of(context).index = 1;
            _controller.selectTab(1);
          }
        },
        child: Card(
          child: ListTile(
            title: Text(
              title,
            ),
          ),
        ),
      );
    });
  }
}
