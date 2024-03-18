import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'untils/path_until/img_path_until.dart';
import 'untils/routers_until/app_router.dart';
import 'untils/routers_until/app_router_name.dart';
import 'untils/themes_until/theme_config.dart';

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
      theme: ThemeUntil.themeData(ThemeUntil.lightTheme),
      darkTheme: ThemeUntil.themeData(ThemeUntil.darkTheme),
      themeMode: ThemeMode.light,
      initialRoute: AppRoutesName.initial,
      getPages: AppRoutes.page,
    );
  }
}
