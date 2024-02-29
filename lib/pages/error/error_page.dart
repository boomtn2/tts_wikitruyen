import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  ErrorPage({super.key, required this.error, this.voidCallBack});
  String error;
  Function? voidCallBack;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(error),
          voidCallBack == null
              ? Container()
              : ElevatedButton(onPressed: () {}, child: Icon(Icons.replay)),
        ],
      ),
    ));
  }
}
