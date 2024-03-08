import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:tts_wikitruyen/html/html.dart';
import 'package:tts_wikitruyen/model/chapter.dart';

import 'package:tts_wikitruyen/model/model.dart';

import 'package:tts_wikitruyen/pages/info/tts/enum_state.dart';
import 'package:tts_wikitruyen/services/local/local.dart';

import 'package:tts_wikitruyen/services/network/network.dart';
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
  List<double> speedData = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
  List<Map<dynamic, dynamic>> voiceList = <Map<dynamic, dynamic>>[].obs;
  RxDouble speedNow = 0.5.obs;
  RxMap<dynamic, dynamic> voiceNow = {}.obs;

  Rx<Chapter> chapter = Chapter.none().obs;
  bool autoLoading = false;
  Chapter? chapterPreload;
  QuerryGetChapterHTML _chapterHTML = QuerryGetChapterHTML.none();

  RxList<String> dataListText = <String>[].obs;
  int start = 0;
  int end = 0;
  RxInt index = 0.obs;
  String textTTS = '';

  String messError = '';
  bool isLoadingChapter = false;

  Client client = Client();
  Rx<UIPlayStatus> uiPlayStatus = UIPlayStatus.error.obs;

  bool isLocal = false;
  Map<String, String> listChapter = {};
  String id = '';

  void setInput(
      {required Chapter chapterBook, required QuerryGetChapterHTML html}) {
    stopTTS();
    isLocal = false;
    messError = '';
    _chapterHTML = html;
    _initWordSpeech();
    chapter.value = chapterBook;
    _setNewDataTTS();

    if (_controllerHandlerTTS.ttsStatus() == TtsStatus.error) {
      _handleError(error: _controllerHandlerTTS.messError());
    }
  }

  void setInputLocal(
      {required Map<String, String> lschapter,
      required String id,
      required String keyChapter,
      required String text,
      required String titleChapter}) {
    stopTTS();
    isLocal = true;
    this.id = id;
    listChapter = lschapter;
    chapter.value = Chapter(
        text: text,
        title: titleChapter,
        linkChapter: keyChapter,
        linkNext: keyChapter,
        linkPre: '');
    _initWordSpeech();
    _setNewDataTTS();
    if (_controllerHandlerTTS.ttsStatus() == TtsStatus.error) {
      _handleError(error: _controllerHandlerTTS.messError());
    }
  }

  void initInfoTTS() {
    voiceList = _controllerHandlerTTS.listVoices() ?? [];
    voiceNow.value = _controllerHandlerTTS.voiceNow() ?? {'Eror': 'Error'};
  }

  void _handleError({required String? error}) {
    uiPlayStatus.value = UIPlayStatus.error;
    messError = error ?? 'Lỗi chưa không xác định';
    if (kDebugMode) print(messError);
  }

  void _setNewDataTTS() {
    final data = splitTextIntoSentences(chapter.value.text);
    dataListText.value = data;
    _controllerHandlerTTS.setTexts(
        index: 0, texts: data, title: chapter.value.title);
  }

  void _initProgressTTS() async {
    _controllerHandlerTTS.progressSpeak = (text, start, end, word, index) {
      this.start = start;
      this.end = end;
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
          isLoadingChapter == false) {
        _autoPlayListChapter();
      }
    });
  }

  void _autoPlayListChapter() async {
    if (chapterPreload != null) {
      chapter.value = chapterPreload!;
      _setNewDataTTS();
      playTTS();
    }
  }

  void _initWordSpeech() {
    start = 0;
    end = 0;
    index.value = 0;
  }

//tts
  void playTTS() async {
    autoLoading = true;

    _controllerHandlerTTS.play();
    if (_controllerHandlerTTS.ttsStatus() != TtsStatus.paused) {
      taiTruocText();
    }
  }

  void preLoad() async {
    if (uiPlayStatus.value == UIPlayStatus.play) {
      uiPlayStatus.value = UIPlayStatus.loading;
      _initWordSpeech();
      final temp =
          await loadChapter(path: chapter.value.linkPre, html: _chapterHTML);
      if (temp != null) {
        chapter.value = temp;
        _setNewDataTTS();
        uiPlayStatus.value = UIPlayStatus.play;
      } else {
        uiPlayStatus.value = UIPlayStatus.error;
      }
    } else if (uiPlayStatus.value == UIPlayStatus.pause) {
      _controllerHandlerTTS.skipToNext();
    }
  }

  void skipTTS() async {
    if (uiPlayStatus.value == UIPlayStatus.play) {
      uiPlayStatus.value = UIPlayStatus.loading;
      _initWordSpeech();
      await taiTruocText();
      if (chapterPreload != null) {
        chapter.value = chapterPreload!;
        _setNewDataTTS();
        uiPlayStatus.value = UIPlayStatus.play;
      } else {
        uiPlayStatus.value = UIPlayStatus.error;
      }
    } else if (uiPlayStatus.value == UIPlayStatus.pause) {
      _controllerHandlerTTS.skipToNext();
    }
  }

  Future taiTruocText() async {
    isLoadingChapter = true;
    final rp = isLocal
        ? await loadChapterLocal()
        : await loadChapter(path: chapter.value.linkNext, html: _chapterHTML);

    if (rp == null) {
      autoLoading = false;
    }
    chapterPreload = rp;

    isLoadingChapter = false;
  }

  final sqlite = DatabaseHelper.internal();
  Future<Chapter?> loadChapterLocal() async {
    int responseCode = await sqlite.daTonTai(id, sqlite.tableChapter);
    if (responseCode != 0) {
      String st = await sqlite.getTextChapterOffline(
          id: id, nChapter: chapter.value.linkNext);
      MapEntry data = _getTitleChapterNextLocal(chapter.value.linkNext);

      return Chapter(
          text: st,
          title: data.key,
          linkChapter: data.key,
          linkNext: data.value,
          linkPre: '');
    } else {
      return null;
    }
  }

  MapEntry<String, String> _getTitleChapterNextLocal(String titleKey) {
    String title = '';
    String titleNext = '';
    int index = 0;

    for (var e in listChapter.entries) {
      if (index == 1) {
        titleNext = e.value;
        break;
      }
      if (e.value.compareTo(titleKey) == 0) {
        title = e.key;
        index = 1;
      }
    }

    return MapEntry(title, titleNext);
  }

  Future<Chapter?> loadChapter(
      {required String path, required QuerryGetChapterHTML html}) async {
    try {
      client.url = path;
      var response = await NetworkExecuter().excute(router: client);

      if (response is dio.Response && response.statusCode == 200) {
        return HTMLHelper().getChapter(
            response: response,
            querryTextChapter: html.querryTextChapter,
            querryLinkNext: html.querryLinkNext,
            querryLinkPre: html.querryLinkPre,
            querryTitle: html.querryTitle,
            linkChapter: path,
            domain: html.domain);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  List<String> splitTextIntoSentences(String inputText) {
    // inputText = inputText.replaceAll(RegExp(r'[^a-zA-ZÀ-ỹ0-9{1,}.!:? "]+'), '');
    inputText = xuLyDauVaoString(inputText);
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

  String xuLyDauVaoString(String inputText) {
    inputText = inputText.replaceAll(r'\n', '.');
    inputText = inputText.replaceAll(RegExp(r'\.+'), '.');
    inputText = inputText.replaceAll('.', '.\n');
    return inputText;
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

  void selectString(String st, int index) {
    int indexTTSSelect = index;
    List<String> dataTTS = [];

    //head < index
    for (int i = 0; i < index; ++i) {
      dataTTS.add(dataListText[i]);
    }

    //between == index
    List<String> between = _slipText(stSlip: st, st: dataListText[index]);
    //get firt index list slip
    dataTTS.addAll(between);
    if (between.length > 1) {
      indexTTSSelect += 1;
    }

    //last index + 1
    for (int i = index + 1; i < dataListText.length; ++i) {
      dataTTS.add(dataListText[i]);
    }

    stopTTS();
    _initWordSpeech();
    dataListText.value = dataTTS;
    _controllerHandlerTTS.setTexts(
        index: indexTTSSelect, texts: dataTTS, title: chapter.value.title);
    if (_controllerHandlerTTS.ttsStatus() == TtsStatus.error) {
      _handleError(error: _controllerHandlerTTS.messError());
    }
  }

  List<String> _slipText({required String stSlip, required String st}) {
    List<String> listStringSplit = st.split(stSlip);

    for (int i = 0; i < listStringSplit.length; ++i) {
      if (i == 0) {
      } else {
        String temp = stSlip + listStringSplit[i];
        listStringSplit[i] = temp;
      }
    }

    return listStringSplit;
  }
}
