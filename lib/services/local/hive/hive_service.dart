import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:tts_wikitruyen/models/book.dart';

class HiveServices {
  HiveServices._();
  static const String _keyHistory = "history_tts";
  static const String _keyFavorite = "favorite_tts";

  static late final Box boxHistory;
  static late final Box boxFavorite;

  static Future init() async {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    boxHistory = await Hive.openBox(_keyHistory);
    boxFavorite = await Hive.openBox(_keyFavorite);
  }

  static addHistory({required Book book}) async {
    await boxHistory.put(book.bookPath, book.toMapFullOption());
  }

  static List<Book> getHistory() {
    List<Book> historys = [];
    boxHistory.toMap().forEach((key, value) {
      historys.add(Book.json(value));
    });
    return historys;
  }
}
