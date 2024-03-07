import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/itembooklist.dart';
import '../home_controller.dart';

class IYoutubePage extends StatelessWidget {
  IYoutubePage({super.key});
  final _controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: _controller.listYoutube.length,
        itemBuilder: (context, index) =>
            BookListItem(book: _controller.listYoutube[index]),
      ),
    );
  }
}
