import 'package:flutter/material.dart';

class DarkTheme {
  static final ThemeData themeData = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFFC00C00),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(
        color: Color.fromRGBO(255, 255, 255, 0.5),
      ),
      fillColor: Color.fromRGBO(255, 255, 255, 0.05),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFF1E1E1E),
      titleTextStyle: TextStyle(
        color: Color.fromRGBO(255, 255, 255, 0.5),
        fontSize: 18,
      ),
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  );
}
