import '../models/models_export.dart';
import '../services/local/local.dart';

class DataPush {
  static BookModel _bookModel = BookModel.none();
  static void pushBook({required BookModel book}) {
    // HiveServices.addBook(book: book);
    _bookModel = book;
  }

  static void pushTagHero(Map<String, String> tags) {
    HiveServices.boxApp.put('tagsHero', tags);
  }

  static Map<String, String> getTagHero() {
    final data = HiveServices.boxApp.get('tagsHero');
    Map<String, String> tags = {};
    if (data != null) {
      try {
        tags = data;
      } catch (e) {
        return {};
      }
    }

    return tags;
  }

  static BookModel getBook() {
    return _bookModel;
    //HiveServices.getBook();
  }

  static void pushStateOffline({required bool isOffline}) {
    HiveServices.addStateOffline(isOffline: isOffline);
  }

  static void isStateOffline() {
    HiveServices.addStateOffline(isOffline: true);
  }

  static void isStateOnline() {
    HiveServices.addStateOffline(isOffline: false);
  }

  static bool getModeIsOffline() {
    return HiveServices.getIsOffline();
  }
}
