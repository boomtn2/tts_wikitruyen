import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tts_wikitruyen/models/tag.dart';
import 'package:tts_wikitruyen/models/tag_custom.dart';

class ConverReponseGist {
  static List<Tag> listTags({required Response response}) {
    List<Tag> listTag = [];
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.data);
      data.forEach((key, value) {
        listTag.add(Tag(nameTag: key, tags: value, querry: value['name']));
      });
    }
    return listTag;
  }

  static List<TagCustom> listTagCustom({required Response response}) {
    List<TagCustom> listTag = [];
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.data);
      data.forEach((key, value) {
        listTag.add(TagCustom(nameTag: key, params: value));
      });
    }
    return listTag;
  }
}
