import 'package:get/get.dart';

import 'pages/tts/handler_tts.dart';
import 'package:audio_service/audio_service.dart';

class DI {
  static void init() {
    Get.putAsync(() => AudioService.init(
        builder: () => HandlerTTS(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.example.tts_wikitruyen',
          androidNotificationChannelName: 'Audio',
          androidNotificationOngoing: true,
        )));
  }
}
