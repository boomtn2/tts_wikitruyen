import 'package:dio/dio.dart';

class NetworkDecore {
  void getListObjects({required Object reponse}) {
    if (reponse is Response) {
      reponse.data;
    }
  }
}
