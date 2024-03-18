import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tts_wikitruyen/views/bookinfo_view/tab_view/tab_audio/widgets/dialog_select_text.dart';

import 'package:tts_wikitruyen/views/widgets/image_networkcustom.dart';
import 'package:tts_wikitruyen/views/widgets/loading_widget.dart';

import '../../../../presenters/bookinfor_presenter/bookinfor_presenter.dart';

import '../../../../untils/path_until/img_path_until.dart';
import '../../widgets/widgets_export.dart';
import 'widgets/widget_button_tts.dart';

class TabAudio extends StatelessWidget {
  TabAudio({super.key});
  final controller = Get.find<BookInforPresenter>();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Stack(
          children: [
            ImageNetWorkCustom(
              link: controller.bookInfoModel.value.book!.imgPath,
              pathAssetImg: pathAssetsIMGBackGroundSlach,
              widgetLoading: const LoadingWidget(),
              boxFit: BoxFit.cover,
              height: 170,
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(
              height: 170,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Card(
                      color: const Color.fromARGB(172, 0, 0, 0),
                      child: ListTile(
                        leading: ButtonPlay(
                          controller: controller,
                        ),
                        title: Text(
                          '[${controller.getStringUIPlayState(controller.uiPlayStatus.value)}]',
                          maxLines: 1,
                          style: const TextStyle(color: Colors.red),
                        ),
                        subtitle: Text(
                          controller.chapter.value.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: ButtonSkip(
                          controller: controller,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: const Color.fromARGB(108, 0, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              controller.nhayDoan();
                              Get.dialog(DialogSelectText());
                            },
                            child: const SizedBox(
                                height: 48,
                                child: Center(child: Text('Nhảy đoạn')))),
                        Expanded(
                          child: ButtonSelectVoices(
                            controller: controller,
                          ),
                        ),
                        ButtonSpeed(
                          controller: controller,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const DividerC(),
        const SectionTitle(
            title: 'Mục lục: (1 lần chưa chuyển thì bấm 2 3 lần vô)'),
        Indexing(),
        const DividerC(),
        const SectionTitle(title: 'Chương (Vuốt lên ):'),
        Expanded(
            child: Container(
          color: Colors.black,
          child: Obx(
            () => controller.chapters.isEmpty
                ? Center(
                    child: controller.isLoadingData.value
                        ? const LoadingWidget()
                        : IconButton(
                            color: Colors.red,
                            onPressed: () {
                              controller.reloadChapters();
                            },
                            icon: const Icon(Icons.replay_outlined)),
                  )
                : GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 60.0,
                    ),
                    children: [
                        InkWell(
                          onTap: () {
                            controller.setMotaChapter();
                          },
                          child: Card(
                            color: controller.chapter.value.title ==
                                    controller.nameDescription
                                ? Colors.amber
                                : null,
                            child: ListTile(
                              title: Text(
                                controller.nameDescription,
                              ),
                            ),
                          ),
                        ),
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
            controller.setChapter(title, value);
          },
          child: Card(
            color:
                controller.chapter.value.title == title ? Colors.amber : null,
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
