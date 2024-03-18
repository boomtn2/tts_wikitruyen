import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ErrorPage extends StatelessWidget {
  ErrorPage(
      {super.key,
      required this.error,
      this.voidCallBack,
      required this.reload});
  String error;
  Function? voidCallBack;
  Function reload;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(error),
          ElevatedButton(
              onPressed: () {
                reload();
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.replay),
                  Text('Thử lại kết nối'),
                ],
              )),
          voidCallBack == null
              ? Container()
              : ElevatedButton(
                  onPressed: () {}, child: const Icon(Icons.replay)),
        ],
      ),
    ));
  }
}
