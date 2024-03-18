import 'package:audio_service/audio_service.dart';

import '../../services/tts/handler_tts.dart';

class SingletonAudiohanle {
  static late HandlerTTS controllerHandlerTTS;
  static final SingletonAudiohanle _singleton = SingletonAudiohanle._internal();

  factory SingletonAudiohanle() {
    return _singleton;
  }

  SingletonAudiohanle._internal() {
    _init();
  }

  void _init() async {
    controllerHandlerTTS = await AudioService.init(
        builder: () => HandlerTTS(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'hit.coder.ttsaudioquanhonngontinh',
          androidNotificationChannelName: 'Audio',
          androidNotificationOngoing: true,
        ));
    listenStreamPlayStatus();
  }

  Function() voidCallbackAuto = () {};
  Function() voidCallUIPlay = () {};
  Function() voidCallUIPause = () {};
  void listenStreamPlayStatus() {
    controllerHandlerTTS.playbackState.listen((value) {
      value.playing ? voidCallUIPause() : voidCallUIPlay();
      voidCallbackAuto();
    });
  }
}
