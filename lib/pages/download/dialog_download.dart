import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/theme/theme_config.dart';
import 'download_controller.dart';

class DialogDownLoad extends StatelessWidget {
  final Function right;
  final Function left;
  final DownloadController controller;
  DialogDownLoad(
      {super.key,
      required this.right,
      required this.left,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: Card(
          color: themeDialog,
          child: SizedBox(
            height: 200,
            width: Get.size.width / 1.2,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Tải Xuống',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                    'Tiến trình: ${controller.startDownload.value}/${controller.getLengthLinks()}  '),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: LinearProgressIndicator(
                    value: (1 -
                        (controller.getLengthLinks() -
                                controller.startDownload.value) /
                            controller
                                .getLengthLinks()), // Giá trị tiến trình (từ 0.0 đến 1.0)
                    minHeight: 10, // Chiều cao của thanh tiến trình
                    backgroundColor:
                        Colors.grey[300], // Màu nền của thanh tiến trình
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.blue), // Màu tiến trình
                  ),
                ),
                const Divider(),
                ElevatedButton(
                    onPressed: () {
                      controller.isStopDownload = true;
                      Get.back();
                    },
                    child: const Text('Hủy bỏ tải')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
