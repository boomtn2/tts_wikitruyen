// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'client_netword.dart';
import 'core/create_network.dart';
import 'untils/untils.dart';

class NetworkExecuter {
  NetworkCreate _network = NetworkCreate();
  Future<Object> excute({required BaseClientGenerator router}) async {
    if (await CheckConnection.isConnection()) {
      return _network.request(route: router);
    } else {
      return ErrorNetWork(
          code: ResponseCode.NO_INTERNET_CONNECTION,
          message: AppStringNetWork.no_internet_error,
          description:
              messageErrorNetWork[AppStringNetWork.no_internet_error] ??
                  'no_internet_error');
    }
  }
}
