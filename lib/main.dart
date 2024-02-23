import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pages/tts/handler_tts.dart';
import 'res/routers/app_router.dart';
import 'res/routers/app_router_name.dart';

void main() async {
  Get.putAsync(() => AudioService.init(
      builder: () => HandlerTTS(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.example.tts_wikitruyen',
        androidNotificationChannelName: 'Audio',
        androidNotificationOngoing: true,
      )));

  runApp(AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutesName.initial,
      getPages: AppRoutes.page,
    );
  }
}
