import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Chapter {
  String text;
  String title;
  String linkChapter;
  String linkNext;
  String linkPre;
  Chapter({
    required this.text,
    required this.title,
    required this.linkChapter,
    required this.linkNext,
    required this.linkPre,
  });

  factory Chapter.none() {
    return Chapter(
        text: '', title: '', linkChapter: '', linkNext: '', linkPre: '');
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'title': title,
      'linkChapter': linkChapter,
      'linkNext': linkNext,
      'linkPre': linkPre,
    };
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      text: map['text'] as String,
      title: map['title'] as String,
      linkChapter: map['linkChapter'] as String,
      linkNext: map['linkNext'] as String,
      linkPre: map['linkPre'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chapter.fromJson(String source) =>
      Chapter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chapter(text: $text, title: $title, linkChapter: $linkChapter, linkNext: $linkNext, linkPre: $linkPre)';
  }
}
