import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:tts_wikitruyen/models/models_export.dart';

class HiveServices {
  HiveServices._();
  static const String _keyApp = "tts_audio_parram";

  static late final Box boxApp;

  static const String stKeyPraramBook = 'book';
  static const String stKeyVersion = 'version';
  static const String stKeyIsOffline = 'offline';
  static const String stKeyDataLeak = 'dataleak';

  static Future init() async {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    boxApp = await Hive.openBox(_keyApp);
  }

  static Future addVersion({required String version}) async {
    version.trim();
    await boxApp.put(stKeyVersion, version);
  }

  static Future addListWebiste({required ListWebsite list}) async {
    await boxApp.put(stKeyDataLeak, list.toJson());
  }

  static ListWebsite getListWebsite() {
    final box = boxApp.get(stKeyDataLeak);
    if (box != null) {
      return ListWebsite.fromJson(box);
    } else {
      return ListWebsite.none();
    }
  }

  static Future addStateOffline({required bool isOffline}) async {
    //1 true 0 false
    await boxApp.put(stKeyIsOffline, isOffline ? '1' : '0');
  }

  static Future addBook({required BookModel book}) async {
    await boxApp.put(stKeyPraramBook, book.toMapFullOption());
  }

  static BookModel getBook() {
    final box = boxApp.get(stKeyPraramBook);
    if (box == null) {
      return BookModel.none();
    } else {
      return BookModel.json(box);
    }
  }

  static String? getVersion() {
    final box = boxApp.get(stKeyVersion);
    return box;
  }

  static bool getIsOffline() {
    final box = boxApp.get(stKeyIsOffline);
    if (box == null || '0'.compareTo('$box') == 0) {
      return false;
    } else {
      return true;
    }
  }
}
