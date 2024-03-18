import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tts_wikitruyen/presenters/search_presenter/search_presenter.dart';

class WidgetSelectWebsite extends StatelessWidget {
  WidgetSelectWebsite({super.key});
  final _controller = Get.find<SearchPresenter>();
  @override
  Widget build(BuildContext context) {
    return widgetSelectedWebsite();
  }

  Widget widgetSelectedWebsite() {
    return Obx(
      () => _controller.listWebsite.value.listWebsite.isEmpty
          ? const SizedBox.shrink()
          : DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _controller.websiteNow.value.website,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  if (value != null) {
                    _controller.changeWebsite(nameWebsite: value);
                  }
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
