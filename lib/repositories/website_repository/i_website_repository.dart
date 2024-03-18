import '../../models/models_export.dart';

abstract class IWebsiteRepository {
  Future<ListWebsite> getListWebsite();
  Future<Website?> findWebsite({required String link});
  Future<int> addListWebsite();
}
