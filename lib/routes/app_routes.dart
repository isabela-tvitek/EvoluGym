import 'package:evolugym/screens/exercises_screen.dart';
import 'package:evolugym/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String homeRoute = '/';
  static const String segundaRoute = '/exercicios';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case segundaRoute:
        return MaterialPageRoute(builder: (_) => ExercisesScreen());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            appBar: AppBar(title: const Text("Tela Não Encontrada")),
            body: const Center(child: Text("Tela não encontrada")),
          );
        });
    }
  }
}
