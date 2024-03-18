import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_wikitruyen/repositories/audio_handle/singleton_audiohanle.dart';

import 'package:tts_wikitruyen/repositories/website_repository/website_repository.dart';

import '../../untils/path_until/img_path_until.dart';
import '../../untils/routers_until/app_router_name.dart';
import '../../services/local/local.dart';

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
    SingletonAudiohanle();
    await HiveServices.init();
    await DatabaseHelper().initDb();
    await WebsiteRepository().addListWebsite();
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
                image: AssetImage(pathAssetsIMGBackGroundSlach),
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
