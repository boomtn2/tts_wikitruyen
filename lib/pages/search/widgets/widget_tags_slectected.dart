import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../search_controller.dart';

class TagsSelected extends StatelessWidget {
  TagsSelected({super.key});
  final _controller = Get.find<SearchPageController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        children: _controller.listTagSelected.entries
            .map((e) => InkWell(
                  onTap: () {
                    _controller.listTagSelected.remove(e.key);
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
                            '${e.key}',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
