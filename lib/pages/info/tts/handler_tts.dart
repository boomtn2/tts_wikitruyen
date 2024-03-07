// ignore_for_file: unused_field
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_tts/flutter_tts.dart';

import 'enum_state.dart';

class HandlerTTS extends BaseAudioHandler {
  HandlerTTS() {
    _initTTS();
  }
  final FlutterTts _controllerTTS = FlutterTts();

  String? _messError;
  TtsStatus _ttsStatus = TtsStatus.unknown;
  List<String>? _listText;
  double _speech = 0.5;
  Map<dynamic, dynamic>? _voiceNow;
  List<Map<dynamic, dynamic>>? _listVoices;
  int? _maxSpeechInputLength;

  Function(String text, int start, int end, String word, int index)
      progressSpeak = (text, start, end, word, index) {};

  int _indexListTexts = 0;
  int _indexPause = 0;

  String? messError() => _messError;
  TtsStatus ttsStatus() => _ttsStatus;
  List<String>? listText() => _listText;
  double speech() => _speech;
  Map<dynamic, dynamic>? voiceNow() => _voiceNow;
  List<Map<dynamic, dynamic>>? listVoices() => _listVoices;
  int? maxSpeechInputLength() => _maxSpeechInputLength;
  int indexListTexts() => _indexListTexts;

  void _handleErrorTTS({required String error}) {
    _setTtsStatus(status: TtsStatus.error);
    _messError = error;

    if (kDebugMode) print(error);
  }

  int _indextContineus = 0;

  void _initTTS() async {
    _setTtsStatus(status: TtsStatus.start);
    _listVoices = await _getVoicesVI_EN();

    if (_listVoices != null) {
      if (_listVoices!.isNotEmpty) {
        setVoice(voice: _listVoices!.first);
      }
    }
    _maxSpeechInputLength = await _controllerTTS.getMaxSpeechInputLength;

    setSpeech(_speech);
    _handlerTTS();
    _interrupSessionAudio();
  }

  bool _isPauseInterrup = false;
  void _interrupSessionAudio() async {
    final session = await AudioSession.instance;
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            pause();
            _isPauseInterrup = true;
            break;
          case AudioInterruptionType.pause:
            pause();
            _isPauseInterrup = true;
            break;
          case AudioInterruptionType.unknown:
            pause();
            _isPauseInterrup = true;
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            if (_ttsStatus == TtsStatus.paused && _isPauseInterrup) {
              play();
              _isPauseInterrup = false;
            }

            break;
          case AudioInterruptionType.pause:
            if (_ttsStatus == TtsStatus.paused && _isPauseInterrup) {
              play();
              _isPauseInterrup = false;
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
    _listText = texts;
    _indexListTexts = 0;
    _indexPause = 0;
    _indextContineus = 0;

    _setTtsStatus(status: TtsStatus.start);
  }

  void setTitle(String id, String title) {
    mediaItem.add(MediaItem(id: id, title: title));
  }

  Future<void> setVoice({required Map<dynamic, dynamic> voice}) async {
    // 1 true 0 flase
    var flag = await _controllerTTS
        .setVoice({"name": voice["name"], "locale": voice["locale"]});
    if (flag == 1) {
      _voiceNow = voice;
    } else {
      _handleErrorTTS(error: 'Lỗi cài đặt giọng: {$voice}');
    }
  }

  Future<void> setSpeech(double speech) async {
    final repo = await _controllerTTS.setSpeechRate(speech);
    if (repo == 1) {
      _speech = speech;
    } else {
      _handleErrorTTS(
          error: 'Lỗi cài đặt tốc độ: {$speech} tốc độ hiện tại là {$_speech}');
    }
  }

  // ignore: non_constant_identifier_names
  Future<List<Map<dynamic, dynamic>>> _getVoicesVI_EN() async {
    String locale = 'vi';
    try {
      List<dynamic> data = await _controllerTTS.getVoices;
      // Assuming getVoices returns a Future<List<Map>>
      List<Map<dynamic, dynamic>> listItem = List.from(data);
      List<Map<dynamic, dynamic>> listVI =
          listItem.where((voice) => voice["locale"].contains(locale)).toList();
      if (listVI.isEmpty) {
        _handleErrorTTS(
            error:
                'Lỗi giọng đọc việt nam không được hỗ trợ trên thiết bị này');
        return listItem;
      } else {
        return listVI;
      }
    } catch (e) {
      _handleErrorTTS(error: 'Lỗi getVoices $e');

      return []; // or handle the error as needed
    }
  }

  void _handlerTTS() async {
    // Auto speak list Texts
    await _controllerTTS.awaitSynthCompletion(true);
    await _controllerTTS.awaitSpeakCompletion(true);
    _controllerTTS.setCompletionHandler(() {
      _nextText();
    });

    _controllerTTS.setProgressHandler((text, start, end, word) {
      _indexPause = end;

      if (_ttsStatus == TtsStatus.resumed) {
        progressSpeak(text, start + _indextContineus, end + _indextContineus,
            word, _indexListTexts);
      } else {
        progressSpeak(text, start, end, word, _indexListTexts);
      }
    });
  }

  void _setTtsStatus({required TtsStatus status}) {
    _ttsStatus = status;
    if (kDebugMode) print(_ttsStatus);
  }

  void _playTTS() async {
    if (_listText != null) {
      if (_ttsStatus != TtsStatus.paused &&
          _indexListTexts < _listText!.length) {
        _setTtsStatus(status: TtsStatus.playing);
        _speak(text: _listText![_indexListTexts]);
      } else if (_ttsStatus == TtsStatus.paused &&
          _indexListTexts < _listText!.length) {
        String newText = _listText![_indexListTexts];

        _setTtsStatus(status: TtsStatus.resumed);
        _speak(text: newText.substring(_indexPause));
      } else {
        _handleErrorTTS(
            error:
                'Không thể play TTS lỗi state: {$_ttsStatus} indexList:{$_indexListTexts}');
      }
    } else {
      _handleErrorTTS(error: 'Lỗi listText is Null');
    }
  }

  void _nextText() {
    if (_listText != null) {
      ++_indexListTexts;
      try {
        if (_indexListTexts < _listText!.length) {
          String text = _listText![_indexListTexts];

          _setTtsStatus(status: TtsStatus.start);
          _speak(text: text);
        } else {
          _setTtsStatus(status: TtsStatus.complate);
          stop();
        }
      } catch (e) {
        _handleErrorTTS(error: 'Error Unknow fct _nextText(): {$e}');
      }
    } else {
      _handleErrorTTS(error: 'ListText input is Null');
    }
  }

  void _pauseTTS() {
    _setTtsStatus(status: TtsStatus.paused);
    _controllerTTS.pause();
  }

  void _stopTTS() {
    if (_ttsStatus != TtsStatus.complate) {
      _setTtsStatus(status: TtsStatus.stopped);
    }
    _controllerTTS.stop();
  }

  void _speak({required String text}) {
    AudioService.androidForceEnableMediaButtons();
    _controllerTTS.speak(text);
  }

  @override
  Future<void> skipToNext() async {
    _setTtsStatus(status: TtsStatus.complate);
    _playStateAudioHandler();
  }

  @override
  Future<void> play() async {
    final session = await AudioSession.instance;
    if (await session.setActive(true)) {
      _playTTS();
      _playStateAudioHandler();
    }
  }

  @override
  Future<void> stop() async {
    _stopTTS();
    _playStateAudioHandler();
  }

  @override
  Future<void> pause() async {
    if (_ttsStatus == TtsStatus.resumed) {
      _indexPause += _indextContineus;
    }
    _indextContineus = _indexPause;

    _pauseTTS();
    _playStateAudioHandler();
  }

  void _playStateAudioHandler() {
    switch (_ttsStatus) {
      case TtsStatus.playing:
        playbackState.add(playbackState.value.copyWith(
          controls: [
            MediaControl.pause,
            MediaControl.skipToNext,
          ],
          processingState: AudioProcessingState.ready,
          playing: true,
        ));
        break;
      case TtsStatus.resumed:
        playbackState.add(playbackState.value.copyWith(
          controls: [
            MediaControl.pause,
            MediaControl.skipToNext,
          ],
          processingState: AudioProcessingState.ready,
          playing: true,
        ));
        break;
      case TtsStatus.paused:
        playbackState.add(playbackState.value.copyWith(
          controls: [
            MediaControl.play,
            MediaControl.skipToNext,
          ],
          processingState: AudioProcessingState.ready,
          playing: false,
        ));
        break;
      case TtsStatus.stopped:
        playbackState.add(playbackState.value.copyWith(
          processingState: AudioProcessingState.idle,
          playing: false,
        ));
        break;
      case TtsStatus.complate:
        playbackState.add(playbackState.value.copyWith(
          processingState: AudioProcessingState.completed,
          playing: false,
        ));
        break;
      case TtsStatus.error:
        playbackState.add(playbackState.value.copyWith(
          processingState: AudioProcessingState.error,
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
