import '../model/model.dart';
import '../services/local/local.dart';

class DataPush {
  static void pushBook({required Book book}) {
    HiveServices.addBook(book: book);
  }

  static void pushTagHero(Map<String, String> tags) {
    HiveServices.boxApp.put('tagsHero', tags);
  }

  static Map<String, String> getTagHero() {
    final data = HiveServices.boxApp.get('tagsHero');
    Map<String, String> tags = {};
    if (data != null) {
      tags = data;
    }

    return tags;
  }

  static Book getBook() {
    return HiveServices.getBook();
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
