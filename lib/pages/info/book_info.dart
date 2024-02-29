import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/info/book_info_controller.dart';
import 'package:tts_wikitruyen/pages/widgets/bottomsheet_custom.dart';

import '../../models/book.dart';
import '../tts/enum_state.dart';
import '../tts/widget_buttonTTS.dart';
import '../widgets/cricle_load.dart';

class BookInfoPage extends StatefulWidget {
  BookInfoPage({super.key});

  @override
  State<BookInfoPage> createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  final BookInfoController _controller = Get.find<BookInfoController>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.controllerTTS.stopTTS();
    _controller.saveHistoryBook();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.9)) {
      if (_controller.isLoadListChapter.value == false)
        _controller.loadMoreChapter();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_controller.nameBook.value),
        ),
        body: Obx(
          () => ListView(
            controller: _scrollController,
            children: [
              Card(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: Get.width / 4,
                      height: Get.height / 6,
                      child: Image.network(
                        _controller.book.imgFullPath,
                        errorBuilder: (context, error, stackTrace) =>
                            SizedBox(),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              text: 'Tác giả: ',
                              children: [
                                TextSpan(
                                    text: '${_controller.book.bookAuthor}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red)),
                              ],
                            ),
                          ),
                          RichText(
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              text: 'Thể loại: ',
                              children: _controller.bookInfo.value.theLoai
                                  .map((e) => TextSpan(
                                      text: '${e.keys},',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue)))
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Mota(),
              ItemListBookSame(),
              ListChapters(),
              _controller.isLoadListChapter.value ? CricleLoad() : Container(),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
        bottomSheet: Obx(() => Visibility(
            visible: _controller.statusLoading.value == StatusLoading.SUCCES,
            child: ButtonsTTS())));
  }
}

class Mota extends StatelessWidget {
  Mota({super.key});
  final _controller = Get.find<BookInfoController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _controller.statusLoading.value == StatusLoading.LOADING
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text("Văn án:"),
                      _controller.isLoadMore.value
                          ? Text(
                              "${_controller.bookInfo.value.moTa}",
                            )
                          : Text(
                              "${_controller.bookInfo.value.moTa}",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                      InkWell(
                        onTap: () {
                          _controller.isLoadMore.value =
                              !_controller.isLoadMore.value;
                        },
                        child: Text(
                          _controller.isLoadMore.value
                              ? "<Thu Nhỏ>"
                              : "Xem Thêm >>",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class ItemListBookSame extends StatelessWidget {
  ItemListBookSame({super.key});
  final _controller = Get.find<BookInfoController>();
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
                return ItemBook(book: _controller.listBookSame[index]);
              }),
        ),
      ),
    );
  }
}

class ListChapters extends StatelessWidget {
  ListChapters({super.key});
  final _controller = Get.find<BookInfoController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ListTile(
          title: Text("DANH SÁCH CHƯƠNG:"),
        ),
        Obx(
          () => Card(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(children: [
                for (int i = 0;
                    i <
                        (_controller.bookInfo.value.dsChuong.length >
                                _controller.maxItemScroll.value
                            ? _controller.maxItemScroll.value
                            : _controller.bookInfo.value.dsChuong.length);
                    ++i)
                  InkWell(
                    onTap: () {
                      _controller.nextToChapterPage(
                          choose: _controller.bookInfo.value.dsChuong[i]);
                    },
                    child: Card(
                      color: Colors.green,
                      child: ListTile(
                        title: Text(
                            "${_controller.bookInfo.value.dsChuong[i].keys}"),
                      ),
                    ),
                  )
              ]),
            ),
          ),
        ),
      ],
    );
  }
}

class ItemBook extends StatelessWidget {
  const ItemBook({super.key, required this.book});
  final Book book;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final controller = Get.find<BookInfoController>();
        controller.book = book;
        controller.init();
      },
      child: Card(
        color: Color.fromARGB(255, 228, 225, 225),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            height: 170,
            width: Get.size.width / 1.5,
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
                  width: Get.size.width / 4,
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
                          '🙄${book.bookViews} 👑${book.bookStar} 💬${book.bookComment}',
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
