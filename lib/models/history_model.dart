class HistoryModel {
  String nameChapter;
  String chapterPath;
  String text;

  HistoryModel(
      {required this.nameChapter,
      required this.chapterPath,
      required this.text});
  Map<String, dynamic> toMap() {
    return {
      'nameChapter': nameChapter,
      'chapterPath': chapterPath,
      'text': text,
    };
  }

  factory HistoryModel.json(Map<dynamic, dynamic> json) {
    return HistoryModel(
        nameChapter: '${json['nameChapter']}',
        chapterPath: '${json['chapterPath']}',
        text: '${json['text']}');
  }
}
