import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkTheme = false;

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }

  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 224, 224, 219),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 224, 224, 219),
      elevation: 0,
    ),
    // textTheme: TextTheme(titleSmall: TextStyle(color: Colors.black),),
  );
  static ThemeData dark = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 84, 84, 84),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 84, 84, 84),
      elevation: 0,
    ),
  );
}
