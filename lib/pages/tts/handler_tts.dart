import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';

import 'package:flutter_tts/flutter_tts.dart';

import 'enum_state.dart';

class HandlerTTS extends BaseAudioHandler {
  HandlerTTS() {
    init();
  }
  final FlutterTts _tTS = FlutterTts();
  List<String> _texts = [];
  int _indexListTexts = 0;
  int _indexPause = 0;
  TtsState _ttsState = TtsState.stopped;
  List<Map<dynamic, dynamic>> _listVoices = [];

  Function progress =
      (String text, int start, int end, String word, int index) {};

  String locale = 'vi';
  double _speechTTS = 0.5;
  Map<dynamic, dynamic> _voiceInstall = {};
  int _indextContineus = 0;
  bool hasInitialized = false;

  void init() async {
    print('inint handler AUdio Service TTS');
    if (hasInitialized == false) {
      inintIndexMaxSpeech();
      if (_listVoices.isEmpty) {
        _listVoices = await _getVoicesVI_EN();
      }

      if (_listVoices.isNotEmpty) {
        setVoice(voice: _listVoices.first);
      }

      setSpeech(_speechTTS);
      _handlerTTS();
      _interrupSessionAudio();
      hasInitialized = true;
    }
  }

  bool isPauseInterrup = false;
  void _interrupSessionAudio() async {
    final session = await AudioSession.instance;
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            pause();
            isPauseInterrup = true;
            break;
          case AudioInterruptionType.pause:
            pause();
            isPauseInterrup = true;
            break;
          case AudioInterruptionType.unknown:
            pause();
            isPauseInterrup = true;
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            if (_ttsState == TtsState.paused && isPauseInterrup) {
              play();
              isPauseInterrup = false;
            }

            break;
          case AudioInterruptionType.pause:
            if (_ttsState == TtsState.paused && isPauseInterrup) {
              play();
              isPauseInterrup = false;
            }
          case AudioInterruptionType.unknown:
            stop();
            break;
        }
      }
    });

    session.becomingNoisyEventStream.listen((_) {
      pause();
    });
  }

  void setTexts({
    required int index,
    required List<String> texts,
    required String title,
  }) {
    //init Audio service
    setTitle(title, title);

    //init tts
    _texts = texts;
    _indexListTexts = 0;
  }

  void setTitle(String id, String title) {
    mediaItem.add(MediaItem(id: id, title: title));
  }

  Future<dynamic> setVoice({required Map<dynamic, dynamic> voice}) async {
    // 1 true 0 flase
    var flag =
        await _tTS.setVoice({"name": voice["name"], "locale": voice["locale"]});
    if (flag == 1) {
      _voiceInstall = voice;
    }
    return flag;
  }

  Future<dynamic> setSpeech(double speech) {
    _speechTTS = speech;
    return _tTS.setSpeechRate(speech);
  }

  Future<List<Map<dynamic, dynamic>>> _getVoicesVI_EN() async {
    try {
      List<dynamic> data = await _tTS.getVoices;
      // Assuming getVoices returns a Future<List<Map>>
      List<Map<dynamic, dynamic>> listItem = List.from(data);

      return listItem
          .where((voice) => voice["locale"].contains(locale))
          .toList();
    } catch (e) {
      return []; // or handle the error as needed
    }
  }

  void _handlerTTS() async {
    // Auto speak list Texts
    await _tTS.awaitSynthCompletion(true);
    await _tTS.awaitSpeakCompletion(true);
    _tTS.setCompletionHandler(() async {
      _autoSpeak();
    });

    _tTS.setProgressHandler((text, start, end, word) {
      _indexPause = end;

      if (_ttsState == TtsState.continued) {
        progress(text, start + _indextContineus, end + _indextContineus, word,
            _indexListTexts);
      } else {
        progress(text, start, end, word, _indexListTexts);
      }
    });
  }

  void _playTTS() async {
    if (_indexListTexts < _texts.length) {
      if (_ttsState == TtsState.stopped && _texts.isNotEmpty) {
        _ttsState = TtsState.playing;
        _speak(text: _texts[_indexListTexts]);
      } else if (_ttsState == TtsState.paused) {
        _ttsState = TtsState.continued;
        String newText = _texts[_indexListTexts];
        _speak(text: newText.substring(_indexPause));
      } else {
        stop();
      }
    }
  }

  int indexMaxSpeech = 1000;
  void inintIndexMaxSpeech() async {
    int? max = await _tTS.getMaxSpeechInputLength;
    indexMaxSpeech = max ?? 1000;
  }

  int getMaxSpeeh() {
    return indexMaxSpeech;
  }

  void _autoSpeak() {
    ++_indexListTexts;
    if (_indexListTexts < _texts.length) {
      String text = _texts[_indexListTexts];
      _speak(text: text);
      _ttsState = TtsState.playing;
    } else {
      stop();
    }
  }

  void _pauseTTS() {
    _ttsState = TtsState.paused;
    _tTS.pause();
  }

  void _stopTTS() {
    _ttsState = TtsState.stopped;
    _tTS.stop();
  }

  void _speak({required String text}) async {
    AudioService.androidForceEnableMediaButtons();
    await _tTS.speak(text);
  }

  TtsState getTtsSate() => _ttsState;
  List<Map<dynamic, dynamic>> getVoices() => _listVoices;
  double getSpeedTTS() => _speechTTS;
  int getIndexTexts() => _indexListTexts;
  Map<dynamic, dynamic> getVoiceInstall() => _voiceInstall;
  @override
  Future<void> skipToNext() async {
    stop();
  }

  @override
  Future<void> play() async {
    final session = await AudioSession.instance;
    if (await session.setActive(true)) {
      _playTTS();
      playStateAudioHandler();
    }
  }

  @override
  Future<void> stop() async {
    _stopTTS();
    playStateAudioHandler();
  }

  @override
  Future<void> pause() async {
    if (_ttsState == TtsState.continued) {
      _indexPause += _indextContineus;
    }
    _indextContineus = _indexPause;

    _pauseTTS();
    playStateAudioHandler();
  }

  void playStateAudioHandler() {
    switch (_ttsState) {
      case TtsState.playing:
        playbackState.add(playbackState.value.copyWith(
          controls: [
            MediaControl.pause,
            MediaControl.skipToNext,
          ],
          processingState: AudioProcessingState.ready,
          playing: true,
        ));
        break;
      case TtsState.continued:
        playbackState.add(playbackState.value.copyWith(
          controls: [
            MediaControl.pause,
            MediaControl.skipToNext,
          ],
          processingState: AudioProcessingState.ready,
          playing: true,
        ));
        break;
      case TtsState.paused:
        playbackState.add(playbackState.value.copyWith(
          controls: [
            MediaControl.play,
            MediaControl.skipToNext,
          ],
          processingState: AudioProcessingState.ready,
          playing: false,
        ));
        break;
      case TtsState.stopped:
        playbackState.add(playbackState.value.copyWith(
          processingState: AudioProcessingState.idle,
          playing: false,
        ));
        break;
      default:
    }
  }

  void loadingPlayState() {
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.loading,
    ));
  }

  void completedPlayState() {
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.completed,
    ));
  }
}
