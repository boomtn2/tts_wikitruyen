import 'package:flutter/material.dart';

import 'package:get/get.dart';

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  const DescriptionTextWidget({super.key, required this.text});

  @override
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();
    _splitText();
  }

  void _splitText() {
    if (widget.text.length > 150) {
      firstHalf = widget.text.substring(0, 150).replaceAll('.', '.\n');
      secondHalf =
          widget.text.substring(150, widget.text.length).replaceAll('.', '.\n');
    } else {
      firstHalf = widget.text;
      secondHalf = '';
    }
  }

  @override
  void didUpdateWidget(covariant DescriptionTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _splitText();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? Text(
              (flag ? firstHalf : (firstHalf + secondHalf))
                  .replaceAll(r'\n', '\n')
                  .replaceAll(r'\r', '')
                  .replaceAll(r"\'", "'"),
              style: TextStyle(
                fontSize: 16.0,
                color: Get.theme.textTheme.bodySmall!.color,
              ),
            )
          : Column(
              children: <Widget>[
                Text(
                  (flag ? ('$firstHalf...') : (firstHalf + secondHalf))
                      .replaceAll(r'\n', '\n\n')
                      .replaceAll(r'\r', '')
                      .replaceAll(r"\'", "'"),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Get.theme.textTheme.bodySmall!.color,
                  ),
                ),
                GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        flag ? 'Xem thêm' : 'Thu nhỏ',
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 15),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
