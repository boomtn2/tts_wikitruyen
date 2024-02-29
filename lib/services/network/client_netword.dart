// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:tts_wikitruyen/services/wiki_truyen/path_wiki.dart';

class WikiBaseClient extends BaseClientGenerator {
  String _baseURL = PathWiki.BASEURL_Wiki;
  String url = '';
  String methodWiki = "Get";
  Map<String, dynamic>? param = null;
  Map<String, dynamic>? headerWiki = null;
  dynamic bodyWiki = null;
  @override
  // TODO: implement baseURL
  String get baseURL => _baseURL;

  @override
  // TODO: implement body
  get body => bodyWiki;

  @override
  // TODO: implement header
  Map<String, dynamic>? get header => headerWiki;

  @override
  // TODO: implement method
  String get method => methodWiki;

  @override
  // TODO: implement path
  String get path => url;

  @override
  // TODO: implement queryParameters
  Map<String, dynamic>? get queryParameters => param;
}

class Client extends BaseClientGenerator {
  String baseURLClient = '';
  String url = '';
  String methodWiki = "Get";
  Map<String, dynamic>? param = null;
  Map<String, dynamic>? headerWiki = null;
  dynamic bodyWiki = null;

  @override
  // TODO: implement baseURL
  String get baseURL => baseURLClient;

  @override
  // TODO: implement body
  get body => bodyWiki;

  @override
  // TODO: implement header
  Map<String, dynamic>? get header => headerWiki;

  @override
  // TODO: implement method
  String get method => methodWiki;

  @override
  // TODO: implement path
  String get path => url;

  @override
  // TODO: implement queryParameters
  Map<String, dynamic>? get queryParameters => param;
}

abstract class BaseClientGenerator {
  const BaseClientGenerator();
  String get path;
  String get method;
  String get baseURL;
  dynamic get body;
  Map<String, dynamic>? get queryParameters;
  Map<String, dynamic>? get header;
  int get sendTimeout => 30000;
  int get receiveTimeOut => 30000;
}
