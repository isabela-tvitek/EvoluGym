import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkTheme = false;

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }

  static const Color primaryGreen = Color(0xFF24BE9A);
  static const Color primaryGreenDark = Color.fromARGB(255, 40, 139, 116);

  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 224, 224, 219),
    primaryColor: primaryGreen,
    colorScheme: const ColorScheme.light(
      primary: primaryGreen,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreen,
      elevation: 0,
    ),
    textTheme: TextTheme(
      bodyLarge: const TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black.withOpacity(0.7)),
      bodySmall: TextStyle(color: Colors.black.withOpacity(0.6)),
    ),
  );

  static ThemeData dark = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 84, 84, 84),
    primaryColor: primaryGreenDark,
    colorScheme: const ColorScheme.dark(
      primary: primaryGreenDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreenDark,
      elevation: 0,
    ),
    textTheme: TextTheme(
      bodyLarge: const TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white.withOpacity(0.7)),
      bodySmall: TextStyle(color: Colors.white.withOpacity(0.6)),
    ),
  );
}