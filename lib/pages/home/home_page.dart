import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/home/home_controller.dart';
import 'package:tts_wikitruyen/res/routers/app_router_name.dart';

import '../../models/book.dart';
import 'pages/i_history_page.dart';

List<Widget> pages = [
  BodyHome(),
  Container(),
  IHistoryPage(),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("AUDIO"),
          actions: [
            InkWell(
              onTap: () => Get.toNamed(AppRoutesName.search),
              child: Card(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    "Tìm Kiếm",
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 30,
                  ),
                ]),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body: pages[_controller.currenPage.value],
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
            onTap: (value) {
              _controller.currenPageFct(indexPage: value);
            },
            currentIndex: _controller.currenPage.value,
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.red,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Truyện"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_outlined), label: "YouTube"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: "Lịch Sử"),
            ]),
      ),
    );
  }
}

class BodyHome extends StatelessWidget {
  BodyHome({super.key});
  final _controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: SizedBox(
              height: 40,
              width: Get.width,
              child: ListView.builder(
                itemCount: _controller.hotTags.length,
                itemBuilder: (context, index) => ButtonTagHotSreach(
                  title: _controller.hotTags[index].nameTag,
                  index: index,
                ),
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
          _controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                ))
              : Expanded(
                  child: ListView.builder(
                      itemCount: _controller.listBooks.length,
                      itemBuilder: (context, index) {
                        if (index == _controller.listBooks.length - 1 &&
                            _controller.isLoadMore.value == false &&
                            _controller.isLoading.value == false) {
                          _controller.loadMoreItems();
                          return Center(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                          ));
                        }

                        return ItemBook(book: _controller.listBooks[index]);
                      }),
                ),
        ],
      ),
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
          if (_controller.indexHotTag.value != index) {
            _controller.selectTag(indexTag: index);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(left: 5),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: _controller.indexHotTag.value == index
                  ? Colors.white
                  : Colors.black,
              border: Border.all(
                color: _controller.indexHotTag.value == index
                    ? Colors.blue
                    : Colors.white30,
                width: _controller.indexHotTag.value == index ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              '${title}',
              style: TextStyle(
                  color: _controller.indexHotTag.value == index
                      ? Colors.black
                      : Colors.white70,
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
      child: Card(
        color: Color.fromARGB(255, 228, 225, 225),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            height: 170,
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
                            fontSize: 20, fontWeight: FontWeight.bold),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${book.bookAuthor}',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 30,
                        child: Text(
                          '🫨${book.bookViews} 👑${book.bookStar} 💬${book.bookComment}',
                          style: TextStyle(fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
