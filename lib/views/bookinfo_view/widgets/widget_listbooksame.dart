import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../presenters/bookinfor_presenter/bookinfor_presenter.dart';
import '../../widgets/itembooklist.dart';

class ItemListBookSame extends StatelessWidget {
  ItemListBookSame({super.key});
  final _controller = Get.find<BookInforPresenter>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        child: SizedBox(
          height: Get.height / 5,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _controller.listBookSame.length,
              itemBuilder: (context, index) {
                return BookListItem(
                  book: _controller.listBookSame[index],
                  funtionOption: () {
                    _controller.selectBookSame(_controller.listBookSame[index]);
                  },
                  optionFull: false,
                );
              }),
        ),
      ),
    );
  }
}
