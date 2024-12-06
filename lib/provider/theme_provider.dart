import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkTheme = false;

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }

  static const Color primaryGreen = Color(0xFF24BE9A);

  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 224, 224, 219), // fundo claro
    primaryColor: primaryGreen,
    colorScheme: const ColorScheme.light(
      primary: primaryGreen, 
      secondary: primaryGreen,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 224, 224, 219),
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
    primaryColor: primaryGreen,
    colorScheme: ColorScheme.dark(
      primary: primaryGreen,
      secondary: primaryGreen,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 84, 84, 84),
      elevation: 0,
    ),
    textTheme: TextTheme(
      bodyLarge: const TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white.withOpacity(0.7)),
      bodySmall: TextStyle(color: Colors.white.withOpacity(0.6)),
    ),
  );
}
