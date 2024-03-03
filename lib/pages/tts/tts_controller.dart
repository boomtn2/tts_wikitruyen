import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:tts_wikitruyen/pages/tts/enum_state.dart';

import 'package:tts_wikitruyen/services/network/network.dart';
import 'package:dio/dio.dart' as dio;
import 'package:tts_wikitruyen/services/wiki_truyen/convert_html.dart';

import '../../services/network/untils/untils.dart';
import 'handler_tts.dart';

enum UIPlayStatus { play, pause, loading, error }

class ControllerTTS {
  static final ControllerTTS _instance = ControllerTTS._internal();
  factory ControllerTTS() {
    return _instance;
  }
  ControllerTTS._internal() {
    _initProgressTTS();
  }
  final HandlerTTS _controllerHandlerTTS = Get.find<HandlerTTS>();
  List<Map<String, String>> linksChapter = [];
  int indexlinksChapter = 0;

  List<double> speedData = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
  List<Map<dynamic, dynamic>> voiceList = <Map<dynamic, dynamic>>[].obs;

  RxDouble speedNow = 0.5.obs;
  RxMap<dynamic, dynamic> voiceNow = {}.obs;
  RxString titleNow = 'Mô Tả'.obs;

  bool autoLoading = false;

  List<String> dataPreload = <String>[];
  RxList<String> data = <String>[].obs;
  RxInt start = 0.obs;
  RxInt end = 0.obs;
  RxInt index = 0.obs;
  String textTTS = '';

  String messError = '';

  bool isLoadingChapter = false;

  BaseHtml convertHtml = ConvertHtml();
  Client client = Client();
  Rx<UIPlayStatus> uiPlayStatus = UIPlayStatus.error.obs;
  void setInput(
      {required String text,
      required int indexLineTexts,
      required List<Map<String, String>> linksChapter,
      required int indexlinksChapter,
      required String tilte}) {
    messError = '';
    initWordSpeech();
    stopTTS();
    voiceList = _controllerHandlerTTS.listVoices() ?? [];
    voiceNow.value = _controllerHandlerTTS.voiceNow() ?? {'Eror': 'Error'};
    data.value = splitTextIntoSentences(text);
    this.linksChapter = linksChapter;
    this.indexlinksChapter = indexlinksChapter;
    titleNow.value = tilte;
    _controllerHandlerTTS.setTexts(index: 0, texts: data, title: tilte);

    if (_controllerHandlerTTS.ttsStatus() == TtsStatus.error) {
      _handleError(error: _controllerHandlerTTS.messError());
    }
  }

  void _handleError({required String? error}) {
    uiPlayStatus.value = UIPlayStatus.error;
    messError = error ?? 'Lỗi chưa không xác định';
    if (kDebugMode) print(messError);
  }

  void _initProgressTTS() async {
    _controllerHandlerTTS.progressSpeak = (text, start, end, word, index) {
      this.start.value = start;
      this.end.value = end;
      this.index.value = index;
      textTTS = text;
    };

    // set state play and auto playlist chapters
    _controllerHandlerTTS.playbackState.listen((value) {
      switch (value.processingState) {
        case AudioProcessingState.loading:
          uiPlayStatus.value = UIPlayStatus.loading;
          break;
        case AudioProcessingState.error:
          _handleError(error: _controllerHandlerTTS.messError());
          break;
        default:
          if (value.playing) {
            uiPlayStatus.value = UIPlayStatus.pause;
          } else {
            uiPlayStatus.value = UIPlayStatus.play;
          }
      }

      if (autoLoading == true &&
          _controllerHandlerTTS.ttsStatus() == TtsStatus.complate &&
          indexlinksChapter < linksChapter.length &&
          linksChapter.isNotEmpty &&
          isLoadingChapter == false) {
        autoPlayListChapter();
      }
    });
  }

  void bookMark(
      {required String path,
      required String chapterName,
      required String stringMark}) async {
    _controllerHandlerTTS.loadingPlayState();
    initWordSpeech();
    stopTTS();

    indexlinksChapter = getIndexChapterInList(choose: {chapterName: path});
    data.value = await loadingTexts(path: path);

    findAndSlipArrays(stringFind: stringMark, arrays: data);
    titleNow.value = linksChapter[indexlinksChapter].entries.first.key;
    _controllerHandlerTTS.setTexts(
        index: 0, texts: data, title: titleNow.value);
    _controllerHandlerTTS.completedPlayState();
    taiTruocText();
  }

  int findAndSlipArrays(
      {required String stringFind, required List<String> arrays}) {
    List<String> newArrays = [];
    int indexArrays = 0;
    for (var element in arrays) {
      int index = element.indexOf(stringFind);
      if (index != -1) {
        // Nếu tìm thấy chuỗi cần tìm
        String part1 = element.substring(0, index);
        String part2 = element.substring(index);
        indexArrays = newArrays.length - 1;
        print("Phần 1: $part1");
        print("Phần 2: $part2");
        newArrays.add(part1);
        newArrays.add(part2);
      } else {
        newArrays.add(element);
      }
    }
    data.value = newArrays;
    return indexArrays;
  }

  void incrementIndexLinkChapter() {
    ++indexlinksChapter;
  }

  void autoPlayListChapter() async {
    if (indexlinksChapter < linksChapter.length &&
        linksChapter.isNotEmpty &&
        dataPreload.isNotEmpty) {
      incrementIndexLinkChapter();
      data.value = dataPreload;
      titleNow.value = linksChapter[indexlinksChapter].entries.first.key;
      _controllerHandlerTTS.setTexts(
          index: 0, texts: data, title: titleNow.value);
      playTTS();
    } else {
      autoLoading = false;
    }
  }

  void initWordSpeech() {
    start.value = 0;
    end.value = 0;
    index.value = 0;
  }

  void loadNewChapter({required int indexPath}) async {
    if (indexPath < linksChapter.length) {
      _controllerHandlerTTS.loadingPlayState();
      initWordSpeech();
      stopTTS();
      indexlinksChapter = indexPath;

      data.value = await loadingTexts(
          path: linksChapter[indexlinksChapter].entries.first.value);
      titleNow.value = linksChapter[indexlinksChapter].entries.first.key;
      _controllerHandlerTTS.setTexts(
          index: 0, texts: data, title: titleNow.value);
      _controllerHandlerTTS.completedPlayState();
      taiTruocText();
    }
  }

  int getIndexChapterInList({required Map<String, String> choose}) {
    for (int i = 0; i < linksChapter.length; ++i) {
      if (linksChapter[i] == choose) {
        return i;
      }
    }
    return 0;
  }

  List<String> getDataText() {
    return data;
  }

//tts
  void playTTS() async {
    if (linksChapter.isNotEmpty) {
      autoLoading = true;
    }

    _controllerHandlerTTS.play();
    if (_controllerHandlerTTS.ttsStatus() != TtsStatus.paused) {
      taiTruocText();
    }
  }

  void skipTTS() async {
    if (autoLoading = true) {
      _controllerHandlerTTS.skipToNext();
    } else {
      loadNewChapter(indexPath: ++indexlinksChapter);
    }
  }

  Future taiTruocText() async {
    isLoadingChapter = true;
    int indexPreLoad = indexlinksChapter + 1;
    if (linksChapter.isNotEmpty) {
      if (indexPreLoad < linksChapter.length) {
        _controllerHandlerTTS.loadingPlayState();
        dataPreload = await loadingTexts(
            path: linksChapter[indexPreLoad].entries.first.value);
        _controllerHandlerTTS.completedPlayState();
      }
    } else {
      autoLoading = false;
    }
    isLoadingChapter = false;
  }

  Future<dynamic> loadingTexts({required String path}) async {
    var data = await loadChapter(path: path);

    return splitTextIntoSentences(data);
  }

  Future<String> loadChapter({required String path}) async {
    client.url = path;
    var response = await NetworkExecuter().excute(router: client);
    String data = '';
    if (response is dio.Response) {
      if (response.statusCode != 200) {
        autoLoading = false;
        _handleError(error: 'loadChapter Error: ${response.statusCode}');
      }
      data = convertHtml.getChapter(response: response, link: path);
    } else {
      autoLoading = false;
      if (response is ErrorNetWork) {
        _handleError(error: response.description);
      }
    }

    return data;
  }

  List<String> splitTextIntoSentences(String inputText) {
    // inputText = inputText.replaceAll(RegExp(r'[^a-zA-ZÀ-ỹ0-9{1,}.!:? "]+'), '');
    inputText = inputText.replaceAll(RegExp(r'\.+'), '.');
    inputText = inputText.replaceAll('.', '.\n');
    List<String> segments = [];
    int maxInput = _controllerHandlerTTS.maxSpeechInputLength() ?? 1000;
    while (inputText.isNotEmpty) {
      int endIndex = inputText.length < maxInput ? inputText.length : maxInput;
      String segment = inputText.substring(0, endIndex);

      // Nếu phần cuối không kết thúc bằng dấu chấm, hãy tìm dấu chấm cuối cùng và cắt đến đó
      if (!segment.endsWith('.')) {
        int lastDotIndex = segment.lastIndexOf('.');
        if (lastDotIndex != -1) {
          segment = segment.substring(0, lastDotIndex + 1);
          endIndex = lastDotIndex + 1;
        }
      }

      segments.add(segment);
      inputText = inputText.substring(endIndex).trimLeft();
    }

    return segments;
  }

  void setSpeedRate({required double speedRate}) async {
    await _controllerHandlerTTS.setSpeech(speedRate);
    speedNow.value = _controllerHandlerTTS.speech();
    if (_controllerHandlerTTS.ttsStatus() == TtsStatus.playing ||
        _controllerHandlerTTS.ttsStatus() == TtsStatus.resumed) {
      pauseTTS();
      playTTS();
    }
  }

  void setVoice({required Map<dynamic, dynamic> voice}) async {
    await _controllerHandlerTTS.setVoice(voice: voice);
    voiceNow.value = _controllerHandlerTTS.voiceNow() ?? {'Error': 'Error'};
    if (_controllerHandlerTTS.ttsStatus() == TtsStatus.playing ||
        _controllerHandlerTTS.ttsStatus() == TtsStatus.resumed) {
      pauseTTS();
      playTTS();
    }
  }

  void pauseTTS() {
    _controllerHandlerTTS.pause();
  }

  void stopTTS() {
    autoLoading = false;

    _controllerHandlerTTS.stop();
  }
}
