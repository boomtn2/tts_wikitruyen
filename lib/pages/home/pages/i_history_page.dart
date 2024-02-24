import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../../models/book.dart';
import '../home_controller.dart';

class IHistoryPage extends StatelessWidget {
  IHistoryPage({super.key});
  final _controller = Get.find<HomeController>();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 40,
          width: Get.size.width,
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: _controller.tagHistory
                  .map((e) => ButtonTagHotSreach(
                        title: e,
                        index: index++,
                      ))
                  .toList()),
        ),
        Expanded(
          child: DefaultTabController(
            initialIndex: 0,
            length: 3,
            child: TabBarView(
              children: <Widget>[
                Obx(
                  ()=> ListView.builder(
                    itemCount: _controller.listHistory.length,
                    itemBuilder: (context, index) =>
                        ItemBook(book: _controller.listHistory[index]),
                  ),
                ),
                Container(
                  child: Text('Màn 2'),
                ),
                Container()
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ButtonTagHotSreach extends StatelessWidget {
  ButtonTagHotSreach({
    super.key,
    required this.title,
    required this.index,
  });
  final String title;
  final int index;
  final _controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          if (_controller.indexTagHistory.value != index) {
            _controller.indexTagHistory.value = index;
          }
        },
        child: Container(
          margin: const EdgeInsets.only(left: 5),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: _controller.indexTagHistory.value == index
                  ? Colors.white
                  : Colors.black,
              border: Border.all(
                color: _controller.indexTagHistory.value == index
                    ? Colors.blue
                    : Colors.white30,
                width: _controller.indexTagHistory.value == index ? 1 : 2,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              '${title}',
              style: TextStyle(
                  color: _controller.indexTagHistory.value == index
                      ? Colors.black
                      : Colors.white60,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class ItemBook extends StatelessWidget {
  ItemBook({super.key, required this.book});
  final Book book;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.find<HomeController>().nextToBookInfor(book: book),
      child: Banner(
        location: BannerLocation.bottomEnd,
        color: Colors.blue,
        message: 'Hôm nay',
        child: Card(
          color: Color.fromARGB(255, 228, 225, 225),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: SizedBox(
              height: 120,
              width: Get.size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(
                            book.imgFullPath,
                          ),
                          fit: BoxFit.fill,
                          onError: (exception, stackTrace) {},
                        )),
                    width: Get.size.width / 3,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${book.bookName}',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${book.bookAuthor}',
                          style: TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${book.history?.nameChapter}',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
