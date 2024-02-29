import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pages/tts/handler_tts.dart';
import 'res/routers/app_router.dart';
import 'res/routers/app_router_name.dart';
import 'services/local/hive/hive_service.dart';

void main() async {
  Get.putAsync(() => AudioService.init(
      builder: () => HandlerTTS(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.example.tts_wikitruyen',
        androidNotificationChannelName: 'Audio',
        androidNotificationOngoing: true,
      )));
  HiveServices.init();
  runApp(AppRoot());
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutesName.initial,
      getPages: AppRoutes.page,
    );
  }
}
