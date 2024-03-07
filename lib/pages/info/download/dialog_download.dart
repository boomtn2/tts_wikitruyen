import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/info/download/status_download.dart';
import 'package:tts_wikitruyen/pages/widgets/loading_widget.dart';

import '../book_info_controller.dart';

class DialogDownload extends StatelessWidget {
  DialogDownload({super.key});
  final _controller = Get.find<BookInfoController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: Card(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tải về',
                  style: Get.textTheme.headlineMedium,
                ),
                Text('Đã tải: [${_controller.countDownload.value}] chương'),
                widgetStatusDownload(_controller.statusDownload.value),
                Text(
                  _controller.chapterDownload.value.title,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.indigo)),
                        onPressed: () {
                          _controller.statusDownload.value =
                              StatusDownload.download;
                          _controller.dowLoad();
                        },
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.download), Text('Bắt đầu tải')],
                        )),
                    ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.red)),
                        onPressed: () {
                          _controller.statusDownload.value =
                              StatusDownload.stop;
                        },
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.cancel), Text('Hủy tải')],
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetStatusDownload(StatusDownload status) {
    Widget widget = const Column(
      children: [
        Text('Trạng thái: '),
        SizedBox(
          height: 50,
          width: 50,
        )
      ],
    );
    switch (status) {
      case StatusDownload.download:
        widget = const Column(
          children: [
            Text('Trạng thái: Đang tải ...'),
            SizedBox(height: 50, width: 50, child: LoadingWidget())
          ],
        );
        break;
      case StatusDownload.cancel:
        widget = const Column(
          children: [
            Text('Trạng thái: Cancel...'),
            SizedBox(
              height: 50,
              width: 50,
            )
          ],
        );
        break;
      case StatusDownload.error:
        widget = Column(
          children: [
            Text('Trạng thái: Lỗi! [${_controller.messError}]'),
            const SizedBox(
              height: 50,
              width: 50,
              child: Icon(Icons.error),
            )
          ],
        );
        break;
      case StatusDownload.stop:
        widget = const Column(
          children: [
            Text('Trạng thái: Chưa bấm bắt đầu tải!'),
            SizedBox(
              height: 50,
              width: 50,
            )
          ],
        );
        break;
      default:
    }
    return widget;
  }
}
