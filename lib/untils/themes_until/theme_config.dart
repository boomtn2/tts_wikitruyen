import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeUntil {
  static const Color lightPrimary = Color(0xffF5F5F5);
  static const Color darkPrimary = Color(0xff1f1f1f);
  static const Color lightAccent = Color(0xff2ca8e2);
  static const Color darkAccent = Color(0xff2ca8e2);
  static const Color lightBG = Colors.white;
  static const Color darkBG = Color(0xff121212);
  static const Color smokeWhite = Color(0xffF5F5F5);
  static const Color colorChosseTag = Color.fromARGB(255, 150, 56, 56);
  static const Color themeDialog = Color(0xffF5F5F5);
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: lightBG,
      brightness: Brightness.light,
    ),
    useMaterial3: false,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBG,
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: smokeWhite,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: lightAccent,
          width: 2.0,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: lightPrimary,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: GoogleFonts.sourceSans3TextTheme().copyWith(),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: darkBG,
      brightness: Brightness.dark,
    ),
    useMaterial3: false,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBG,
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: darkPrimary,
    ),
    tabBarTheme: const TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: lightAccent,
          width: 2.0,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: darkPrimary,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );

  static ThemeData themeData(ThemeData theme) {
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
