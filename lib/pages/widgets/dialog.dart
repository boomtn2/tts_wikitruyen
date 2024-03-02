import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/theme/theme_config.dart';

class DialogCustom extends StatelessWidget {
  final Function right;
  final Function left;
  final String title;
  final String mess;

  final String titleRight;
  final String titleLeft;

  const DialogCustom(
      {super.key,
      required this.right,
      required this.left,
      this.title = 'Lịch Sử Đọc',
      required this.mess,
      this.titleRight = 'Tiếp Tục Lịch Sử',
      this.titleLeft = 'Đọc Từ Đầu'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: themeDialog,
        child: SizedBox(
          height: 200,
          width: Get.size.width / 1.2,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Text(
                mess,
                style: Get.textTheme.titleLarge,
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        left();
                      },
                      child: Text(titleLeft)),
                  ElevatedButton(
                      onPressed: () {
                        right();
                      },
                      child: Text(titleRight)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
