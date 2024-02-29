import 'package:get/get.dart';
import 'package:tts_wikitruyen/services/network/client_netword.dart';
import 'package:tts_wikitruyen/services/network/network.dart';
import 'package:dio/dio.dart' as dio;
import 'package:tts_wikitruyen/services/wiki_truyen/convert_html.dart';
import 'enum_state.dart';
import 'handler_tts.dart';

class ControllerTTS {
  static final ControllerTTS _instance = ControllerTTS._internal();
  factory ControllerTTS() {
    return _instance;
  }
  ControllerTTS._internal() {
    initProgressTTS();
  }
  final HandlerTTS _controllerHandlerTTS = Get.find<HandlerTTS>();
  List<Map<String, String>> pathChapters = [];
  int indexPathChapters = 0;
  RxBool isPlay = false.obs;

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

  RxBool error = false.obs;
  String messError = '';

  bool isLoading = false;

  BaseHtml convertHtml = ConvertHtml();
  Client client = Client();
  void setInput(
      {required String text,
      required int indexLineTexts,
      required List<Map<String, String>> pathChapters,
      required int indexPathChapters,
      required String tilte}) {
    error.value = false;
    messError = '';
    initWordSpeech();
    stopTTS();

    data.value = splitTextIntoSentences(text);
    this.pathChapters = pathChapters;
    this.indexPathChapters = indexPathChapters;
    titleNow.value = tilte;

    _controllerHandlerTTS.setTexts(
        index: indexLineTexts, texts: data, title: tilte);

    initProgressTTS();
    if (_controllerHandlerTTS.getTtsSate() == TtsState.error) {
      error.value = true;
      messError = 'Error TTS';
    }
  }

  void initProgressTTS() async {
    _controllerHandlerTTS.progress =
        (String text, int start, int end, String word, int index) {
      this.start.value = start;
      this.end.value = end;
      this.index.value = index;
    };
    voiceList = _controllerHandlerTTS.getVoices();
    voiceNow.value = voiceList.first;
    // set state play and auto playlist chapters
    _controllerHandlerTTS.playbackState.listen((value) {
      isPlay.value = value.playing;
      if (autoLoading == true &&
          _controllerHandlerTTS.getTtsSate() == TtsState.stopped &&
          indexPathChapters < pathChapters.length &&
          pathChapters.isNotEmpty &&
          isLoading == false) {
        autoPlayListChapter();
        print('autoload');
        playTTS();
      }
    });
  }

  void autoPlayListChapter() async {
    if (indexPathChapters < pathChapters.length && pathChapters.isNotEmpty) {
      data.value = dataPreload;
      titleNow.value = pathChapters[indexPathChapters].entries.first.key;
      _controllerHandlerTTS.setTexts(
          index: 0, texts: data, title: titleNow.value);
    } else {
      autoLoading = false;
    }
  }

  void initWordSpeech() {
    this.start.value = 0;
    this.end.value = 0;
    this.index.value = 0;
  }

  void loadNewChapter({required int indexPath}) async {
    if (indexPath < pathChapters.length) {
      _controllerHandlerTTS.loadingPlayState();
      initWordSpeech();
      stopTTS();
      indexPathChapters = indexPath;
      data.value = await loadingTexts(
          path: pathChapters[indexPathChapters].entries.first.value);
      titleNow.value = pathChapters[indexPathChapters].entries.first.key;
      _controllerHandlerTTS.setTexts(
          index: 0, texts: data, title: titleNow.value);
      _controllerHandlerTTS.completedPlayState();
      taiTruocText();
    }
  }

  int getIndexChapterInList({required Map<String, String> choose}) {
    for (int i = 0; i < pathChapters.length; ++i) {
      if (pathChapters[i] == choose) {
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
    if (pathChapters.isNotEmpty) {
      autoLoading = true;
    }

    _controllerHandlerTTS.play();
    if (_controllerHandlerTTS.getTtsSate() == TtsState.stopped) {
      taiTruocText();
    }
  }

  void skipTTS() async {
    if (autoLoading = true) {
      _controllerHandlerTTS.skipToNext();
    } else {
      loadNewChapter(indexPath: ++indexPathChapters);
    }
  }

  Future taiTruocText() async {
    isLoading = true;
    if (pathChapters.isNotEmpty) {
      ++indexPathChapters;
      if (indexPathChapters < pathChapters.length) {
        _controllerHandlerTTS.loadingPlayState();
        dataPreload = await loadingTexts(
            path: pathChapters[indexPathChapters].entries.first.value);
        _controllerHandlerTTS.completedPlayState();
      }
    } else {
      autoLoading = false;
    }
    isLoading = false;
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
        error.value = true;
        messError = 'loadChapter Error: ${response.statusCode}';
      }
      data = convertHtml.getChapter(response: response);
    } else {
      autoLoading = false;
      error.value = true;
      messError = 'loadChapter Error: ${response}';
    }

    return data;
  }

  List<String> splitTextIntoSentences(String inputText) {
    //inputText = inputText.replaceAll(RegExp(r'[^a-zA-ZÀ-ỹ0-9{1,}.!:? ]+'), '');
    inputText = inputText.replaceAll('.', '.\n');
    List<String> segments = [];

    while (inputText.isNotEmpty) {
      int endIndex = inputText.length < _controllerHandlerTTS.getMaxSpeeh()
          ? inputText.length
          : _controllerHandlerTTS.getMaxSpeeh();
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
    var value = await _controllerHandlerTTS.setSpeech(speedRate);
    if (value == 1) {
      speedNow.value = _controllerHandlerTTS.getSpeedTTS();
      if (isPlay.value) {
        pauseTTS();
        playTTS();
      }
    }
  }

  void setVoice({required Map<dynamic, dynamic> voice}) async {
    var value = await _controllerHandlerTTS.setVoice(voice: voice);
    if (value == 1) {
      voiceNow.value = _controllerHandlerTTS.getVoiceInstall();

      if (isPlay.value) {
        pauseTTS();
        playTTS();
      }
    }
  }

  void pauseTTS() {
    print('pause');
    _controllerHandlerTTS.pause();
  }

  void stopTTS() {
    autoLoading = false;
    _controllerHandlerTTS.stop();
  }
}
