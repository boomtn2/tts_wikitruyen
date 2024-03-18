import 'package:equatable/equatable.dart';

class TTSModel extends Equatable {
  final List<double> _speedData = [
    0.1,
    0.2,
    0.3,
    0.4,
    0.5,
    0.6,
    0.7,
    0.8,
    0.9,
    1.0
  ];

  List<Map<dynamic, dynamic>> _voiceList = <Map<dynamic, dynamic>>[];
  double _speedNow = 0.5;
  Map<dynamic, dynamic> _voiceNow = {};
  int _maxInputTTS = 1000;
  List<String> _dataListText = <String>[];

  List<double> getSpeedData() => _speedData;
  List<Map<dynamic, dynamic>> getVoiceList() => _voiceList;
  double getSpeedNow() => _speedNow;
  Map<dynamic, dynamic> getVoiceNow() => _voiceNow;
  int getMaxInput() => _maxInputTTS;
  List<String> getDataList() => _dataListText;

  void voiceList(List<Map<dynamic, dynamic>>? voices) {
    _voiceList = voices ?? _voiceList;
  }

  void speedNow(double? speed) {
    _speedNow = speed ?? _speedNow;
  }

  void voiceNow(Map<dynamic, dynamic>? voice) {
    _voiceNow = voice ?? _voiceNow;
  }

  void maxInputTTS(int? max) {
    _maxInputTTS = max ?? _maxInputTTS;
  }

  void dataListText(List<String>? data) {
    _dataListText = data ?? _dataListText;
  }

  List<String> splitTextIntoSentences(String inputText) {
    // inputText = inputText.replaceAll(RegExp(r'[^a-zA-ZÀ-ỹ0-9{1,}.!:? "]+'), '');
    inputText = xuLyDauVaoString(inputText);
    List<String> segments = [];

    while (inputText.isNotEmpty) {
      int endIndex =
          inputText.length < _maxInputTTS ? inputText.length : _maxInputTTS;
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

  @override
  List<Object?> get props => [_speedNow, _voiceNow, _dataListText];
}
