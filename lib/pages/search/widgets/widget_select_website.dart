import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../search_controller.dart';

class WidgetSelectWebsite extends StatelessWidget {
  WidgetSelectWebsite({super.key});
  final _controller = Get.find<SearchPageController>();
  @override
  Widget build(BuildContext context) {
    return widgetSelectedWebsite();
  }

  Widget widgetSelectedWebsite() {
    return Obx(
      () => DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _controller.websiteNow.value.website,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
          },
          items: _controller
              .listStringNameWebsite()
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
