import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../search_controller.dart';

class ItemSearchPage extends StatelessWidget {
  ItemSearchPage({super.key});
  final _controller = Get.find<SearchPageController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller.controllerTextSearchName,
                    decoration: InputDecoration(
                      hintText: 'Nhập tên truyện / Tên Tác giả',
                      suffixIcon: IconButton(
                        onPressed: () {
                          _controller.controllerTextSearchName.text = '';
                        },
                        icon: Icon(Icons.close),
                        color: Colors.red,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    DefaultTabController.of(context).animateTo(1);
                  },
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.blue,
                    ),
                    height: 55,
                    child: Center(child: Text('Tìm Kiếm')),
                  ),
                ),
              ],
            ),
          ),
          Wrap(
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
                              Icon(
                                Icons.close,
                                size: 15,
                                color: Colors.red,
                              ),
                              Text(
                                '${e.key}',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: () {
                _controller.searchCategory();
                DefaultTabController.of(context).animateTo(1);
              },
              child: Text(
                "Tìm Kiếm Thể loại",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
          Column(
              mainAxisSize: MainAxisSize.max,
              children: _controller.listTags
                  .map(
                    (e2) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('${e2.nameTag}'),
                        ),
                        Wrap(
                            children: e2.tags.entries
                                .map((e) => e.key == 'name'
                                    ? SizedBox()
                                    : ElevatedButton(
                                        style: _controller
                                                    .listTagSelected[e.key] !=
                                                null
                                            ? ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              )
                                            : ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                              ),
                                        onPressed: () {
                                          _controller.selectTag(
                                              name: e.key,
                                              param: e.value,
                                              querry: '${e2.tags['name']}');
                                        },
                                        child: Text('${e.key}')))
                                .toList()),
                      ],
                    ),
                  )
                  .toList()),
          SizedBox(
            height: 70,
          ),
        ],
      ),
    );
  }
}
