import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:tts_wikitruyen/html/html.dart';

import '../search_controller.dart';
import 'widget_tags_slectected.dart';

class ItemSearchPage extends StatelessWidget {
  ItemSearchPage({super.key});
  final _controller = Get.find<SearchPageController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        itemSearchName(context),
        const Divider(),
        TagsSelected(),
        ElevatedButton(
            onPressed: () {
              _controller.searchCategory();
              currentPageListBook(context);
            },
            child: const Text('Tìm kiếm thể loại:')),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Divider(),
                      Title(
                          color: Colors.red,
                          child: Text(
                              _controller.listGrTagSearch[index].namegroup)),
                      Wrap(
                        spacing: 5,
                        children: _controller.listGrTagSearch[index].tags
                            .map((e) => widgetSelect(
                                isSelected: _controller.isTagSelected(e),
                                tagSearch: e))
                            .toList(),
                      )
                    ],
                  ),
                );
              },
              itemCount: _controller.listGrTagSearch.length,
            ),
          ),
        )
      ],
    );
  }

  Widget widgetSelect(
      {required bool isSelected, required TagSearch tagSearch}) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(
              isSelected ? Colors.red : Colors.grey),
        ),
        onPressed: () {
          _controller.selectTag(tagSearch: tagSearch);
        },
        child: Text(
          tagSearch.nametag,
          style: const TextStyle(color: Colors.black),
        ));
  }

  Widget itemSearchName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _controller.controllerTextSearchName,
        decoration: InputDecoration(
            prefixIcon: ElevatedButton.icon(
                onPressed: () {
                  _controller.searchName();
                  currentPageListBook(context);
                },
                icon: const Icon(Icons.search),
                label: const Text('Tìm tên')),
            border: const OutlineInputBorder(),
            hintText: 'Nhập tên truyện / tác giả cần tìm'),
      ),
    );
  }

  void currentPageListBook(BuildContext context) {
    DefaultTabController.of(context).index = 1;
  }
}
