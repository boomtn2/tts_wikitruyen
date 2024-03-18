import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../presenters/search_presenter/search_presenter.dart';

class TagsSelected extends StatelessWidget {
  TagsSelected({super.key});
  final _controller = Get.find<SearchPresenter>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: 70,
        child: Wrap(
          children: _controller.selectedTag
              .map((e) => InkWell(
                    onTap: () {
                      _controller.removeTagSected(tagSearch: e);
                    },
                    child: Card(
                      color: Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.close,
                              size: 15,
                              color: Colors.red,
                            ),
                            Text(
                              e.nametag,
                              style: const TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}