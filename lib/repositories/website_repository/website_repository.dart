import 'package:tts_wikitruyen/models/html_model.dart';
import 'package:tts_wikitruyen/repositories/website_repository/i_website_repository.dart';
import 'package:tts_wikitruyen/services/local/hive/hive_service.dart';

import '../../services/network/network.dart';
import '../../untils/api_until/api_until.dart';
import 'package:dio/dio.dart' as dio;

class WebsiteRepository implements IWebsiteRepository {
  final _network = NetworkExecuter();
  final Client _client = Client();
  @override
  Future<int> addListWebsite() async {
    _client.baseURLClient = APIUntil.linkJsonWebsite;
    final reponse = await _network.excute(router: _client);

    if (reponse is dio.Response && reponse.statusCode == 200) {
      ListWebsite listWebsite = ListWebsite.fromJson(reponse.data);

      await HiveServices.addListWebiste(list: listWebsite);
      await HiveServices.addVersion(version: listWebsite.version);
      return 1;
    } else {
      return 0;
    }
  }

  @override
  Future<Website?> findWebsite({required String link}) async {
    Uri? uri = Uri.tryParse(link);
    if (uri != null) {
      final ListWebsite listWebsite = await getListWebsite();
      for (var element in listWebsite.listWebsite) {
        if (element.domain.contains(uri.host)) {
          return element;
        }
      }

      if (listWebsite.listWebsite.isNotEmpty) {
        return listWebsite.listWebsite.first;
      }
    }

    return null;
  }

  @override
  Future<ListWebsite> getListWebsite() async {
    return HiveServices.getListWebsite();
  }
}
