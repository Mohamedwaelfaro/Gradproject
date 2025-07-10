import 'package:flutter/material.dart';

ThemeData dark_theme() {
  return ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: const Color(0xFF181818),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF232323),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
      primarySwatch: Colors.green,
    ).copyWith(secondary: Colors.greenAccent),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
    iconTheme: const IconThemeData(color: Colors.greenAccent),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.white,
      contentTextStyle: TextStyle(color: Colors.black),
    ),
  );
}

ThemeData light_theme() {
  return ThemeData(
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.green,
    ).copyWith(secondary: Colors.greenAccent),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
    iconTheme: const IconThemeData(color: Colors.green),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.black87,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
  );
}
