import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/html/html.dart';

import '../../dependence_injection.dart';
import '../../res/routers/app_router_name.dart';
import '../../services/local/local.dart';
import '../../services/network/network.dart';
import '../../res/string_link/string_link.dart';
import 'package:dio/dio.dart' as dio;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    WidgetsFlutterBinding.ensureInitialized();
    DI.init();
    await HiveServices.init();
    await DatabaseHelper().initDb();

    final network = NetworkExecuter();
    Client client = Client();
    client.baseURLClient = linkJsonWebsite;
    final reponse = await network.excute(router: client);
    String? versionNow = HiveServices.getVersion();

    if (reponse is dio.Response && reponse.statusCode == 200) {
      ListWebsite listWebsite = ListWebsite.fromJson(reponse.data);

      await HiveServices.addListWebiste(list: listWebsite);
      await HiveServices.addVersion(version: listWebsite.version);
    } else {
      Get.snackbar('Error', '$reponse');
    }
    if (kDebugMode) {
      print(HiveServices.getListWebsite().toJson());
      print(HiveServices.getVersion());
    }

    Get.offNamed(AppRoutesName.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/avt.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Quá trình này yêu cầu mạng nha:",
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 150,
                child: LinearProgressIndicator(
                  backgroundColor: Color.fromARGB(255, 17, 16, 16),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                ),
              ),
              SizedBox(height: 16.0),
              Text('Đợi Mình Xíu Nha...'),
            ],
          ),
        ],
      ),
    );
  }
}
