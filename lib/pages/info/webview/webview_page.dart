import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/pages/info/webview/widget/button_indexing.dart';
import 'package:tts_wikitruyen/pages/widgets/loading_widget.dart';

import 'webview_export.dart';
import 'widget/widget_listchapter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage(
      {super.key, required this.controller, required this.fctCallBack});
  final WVController controller;
  final Function(String titleChapter, String linkChapter) fctCallBack;
  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  void dispose() {
    widget.controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ButtonIndexing(wvController: widget.controller),
          widget.controller.loading.value
              ? const LoadingWidget()
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    WidgetListChapters(
                      fctCallBack: (titleChapter, linkChapter) {
                        widget.fctCallBack(titleChapter, linkChapter);
                      },
                      controller: widget.controller,
                    ),
                    ButtonIndexing(wvController: widget.controller),
                  ],
                ),
        ],
      ),
    );
  }
}
