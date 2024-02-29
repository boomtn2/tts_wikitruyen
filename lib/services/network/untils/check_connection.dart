import 'package:connectivity_plus/connectivity_plus.dart';

class CheckConnection {
  static Future<bool> isConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      return true;
    } else if (connectivityResult == ConnectivityResult.vpn) {
      return true;
    } else {
      return false;
    }
  }
}
