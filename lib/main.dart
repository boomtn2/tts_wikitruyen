import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tts_wikitruyen/dependence_injection.dart';
import 'package:tts_wikitruyen/res/const_app.dart';

import 'res/routers/app_router.dart';
import 'res/routers/app_router_name.dart';
import 'res/theme/theme_config.dart';
import 'services/local/hive/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DI.init();
  HiveServices.init();
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
