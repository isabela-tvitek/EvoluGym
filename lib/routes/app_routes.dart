import 'package:flutter/material.dart';
import 'package:evolugym/screens/add_exercise_screen.dart';
import 'package:evolugym/screens/exercises_screen.dart';
import 'package:evolugym/screens/home_screen.dart';

class AppRoutes {
  static const String homeRoute = '/';
  static const String exercisesRoute = '/exercicios';
  static const String addExerciseRoute = '/add-exercicio';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case exercisesRoute:
        return MaterialPageRoute(builder: (_) => ExercisesScreen());
      case addExerciseRoute:
        return MaterialPageRoute(builder: (_) => AddExerciseScreen());
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
