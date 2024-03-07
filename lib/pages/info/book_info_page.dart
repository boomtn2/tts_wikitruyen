import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tts_wikitruyen/pages/info/book_info_controller.dart';

import 'book_info_page_offline.dart';
import 'book_info_page_online.dart';
import 'download/dialog_download.dart';

import 'tts/widget_buttonTTS.dart';

class BookInfoPage extends StatefulWidget {
  const BookInfoPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BookInfoPage> createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  final BookInfoController _controller = Get.find<BookInfoController>();

  @override
  void dispose() {
    _controller.controllerTTS.stopTTS();
    _controller.saveHistoryBook();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                if (_controller.isChapter.value) {
                  _controller.isChapter.value = false;
                } else {
                  Get.back();
                }
              },
              icon: const Icon(Icons.arrow_back)),
          actions: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigo)),
                  onPressed: () => Get.dialog(DialogDownload()),
                  child: const Icon(Icons.download)),
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.only(bottom: 15, top: 15),
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 157, 171, 173))),
                    label: const Text('Yêu Thích'),
                    onPressed: () => _controller.saveFavorite(),
                    icon: Icon(
                      Icons.favorite,
                      color: _controller.isFavorite.value
                          ? Colors.red
                          : Colors.black,
                    )),
              ),
            ),
          ],
        ),
        body: _controller.isModeOffline.value
            ? const BookInfoPageOffline()
            : const BookInfoPageOnline(),
        bottomSheet: ButtonsTTS());
  }
}
