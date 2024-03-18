import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';

import '../../../presenters/presenters_export.dart';
import 'c_divider.dart';
import 'widget_indexing.dart';
import 'widget_section_title.dart';

class DialogDownload extends StatelessWidget {
  DialogDownload({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: BodyDialodDownload(),
    );
  }
}

class BodyDialodDownload extends StatefulWidget {
  const BodyDialodDownload({super.key});

  @override
  State<BodyDialodDownload> createState() => _BodyDialodDownloadState();
}

class _BodyDialodDownloadState extends State<BodyDialodDownload> {
  final controller = Get.find<BookInforPresenter>();

  @override
  void didChangeDependencies() {
    DefaultTabController.of(context).addListener(() {
      if (DefaultTabController.of(context).index == 1) {
        controller.getChaptersDownloaded();
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.stateDownloadStop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TẢI XUỐNG'),
        bottom: const TabBar(
          tabs: <Widget>[
            Tab(
              text: 'Tải Xuống',
              icon: Icon(Icons.download),
            ),
            Tab(
              text: 'Chương đã tải',
              icon: Icon(Icons.save),
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: <Widget>[_tabDownload(), _tabChapters()],
      ),
    );
  }

  Widget _tabChapters() {
    return Builder(builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Obx(
              () => ListView(
                children: controller.chaptersDownloaded.entries
                    .map((e) => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(e.value),
                              subtitle: Text(e.key),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red)),
            onPressed: () {
              controller.deleteDownload();
            },
            child: const Text('Xóa tất cả'),
          )
        ],
      );
    });
  }

  Widget _sateDownloading() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const CircularProgressIndicator(),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              controller.chapterDownload.value.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red)),
            onPressed: () {
              controller.stateDownloadStop();
            },
            child: const Text('Hủy tải')),
      ],
    );
  }

  Widget _tabDownload() {
    return Column(
      children: [
        Obx(
          () => SizedBox(
            height: Get.size.height / 4,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                controller.uiDownloadStatus.value == UIDownloadStatus.stop
                    ? ElevatedButton(
                        onPressed: () {
                          controller.download();
                        },
                        child: const Text('Bắt đầu tải'))
                    : _sateDownloading(),
              ],
            ),
          ),
        ),
        const DividerC(),
        const SectionTitle(
            title: 'Mục lục: (1 lần chưa chuyển thì bấm 2 3 lần vô)'),
        Indexing(),
        const DividerC(),
        const SectionTitle(title: 'Chọn chapter bắt đầu tải'),
        Expanded(
            child: Container(
          color: Colors.black,
          child: Obx(
            () => GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 60.0,
                ),
                children: [
                  ...controller.chapters.entries
                      .map((e) => buttonChapter(e.value, e.key))
                      .toList()
                ]),
          ),
        )),
      ],
    );
  }

  Widget buttonChapter(String title, String value) {
    return Builder(builder: (context) {
      return Obx(
        () => InkWell(
          onTap: () {
            controller.setChapterDownload(title, value);
          },
          child: Card(
            color: controller.chapterDownload.value.title == title
                ? Colors.amber
                : null,
            child: ListTile(
              title: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );
    });
  }
}
