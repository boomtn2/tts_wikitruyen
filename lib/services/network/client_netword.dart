// ignore_for_file: public_member_api_docs, sort_constructors_first

class Client extends BaseClientGenerator {
  String baseURLClient = '';
  String url = '';
  String methodWiki = "Get";
  Map<String, dynamic>? param;
  Map<String, dynamic>? headerWiki;
  dynamic bodyWiki;

  @override
  String get baseURL => baseURLClient;

  @override
  get body => bodyWiki;

  @override
  Map<String, dynamic>? get header => headerWiki;

  @override
  String get method => methodWiki;

  @override
  String get path => url;

  @override
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
