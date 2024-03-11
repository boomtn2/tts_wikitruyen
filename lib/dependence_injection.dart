import 'package:get/get.dart';

import 'pages/info/tts/handler_tts.dart';
import 'package:audio_service/audio_service.dart';

class DI {
  static void init() {
    Get.putAsync(
        () => AudioService.init(
            builder: () => HandlerTTS(),
            config: const AudioServiceConfig(
              androidNotificationChannelId: 'hit.coder.ttsaudioquanhonngontinh',
              androidNotificationChannelName: 'Audio',
              androidNotificationOngoing: true,
            )),
        permanent: true);
  }
}
