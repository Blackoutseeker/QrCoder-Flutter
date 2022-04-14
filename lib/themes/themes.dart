import 'package:flutter/material.dart';

class Dark {
  final ThemeData theme = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFFC00C00),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: const TextStyle(
        color: const Color.fromRGBO(255, 255, 255, 0.5),
      ),
      fillColor: const Color.fromRGBO(255, 255, 255, 0.05),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      titleTextStyle: const TextStyle(
        color: const Color.fromRGBO(255, 255, 255, 0.5),
        fontSize: 18,
      ),
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  );
}
