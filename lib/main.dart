import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tts_wikitruyen/pages/error/error_controller.dart';
import 'package:tts_wikitruyen/res/const_app.dart';

import 'pages/tts/handler_tts.dart';
import 'res/routers/app_router.dart';
import 'res/routers/app_router_name.dart';
import 'res/theme/theme_config.dart';
import 'services/local/hive/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.putAsync(() => AudioService.init(
      builder: () => HandlerTTS(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.example.tts_wikitruyen',
        androidNotificationChannelName: 'Audio',
        androidNotificationOngoing: true,
      )));
  HiveServices.init();
  Get.put(ErrorController(), permanent: true);
  runApp(const AppRoot());
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: nameApp,
      theme: themeData(lightTheme),
      darkTheme: themeData(darkTheme),
      themeMode: ThemeMode.light,
      initialRoute: AppRoutesName.initial,
      getPages: AppRoutes.page,
    );
  }

  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSans3TextTheme(
        theme.textTheme,
      ),
      colorScheme: theme.colorScheme.copyWith(
        secondary: lightAccent,
      ),
    );
  }
}
